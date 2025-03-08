local omginstance_factory = require("project.utils.omginstance_factory")
local server_messages = require("project.messages.server_messages")
local game_messages = require("project.messages.game_messages")
local game_events = require("project.messages.game_events")

local client_manager
client_manager = {
	create = function(self)

		local send_service_message = function(omginstance, message)
			local encoded_message = json.encode(message)
			omginstance:send_service_message(encoded_message)
		end

		local send_game_message = function(omginstance, message)
			omginstance:send_binary_message(json.encode(message))
		end
		
		return {
			qualifier = "client_manager",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				return true
			end,
			client_started = function(instance, components, event)
				print(os.date() .. " [CLIENT_MANAGER] Client started")
				components.client_state:set_in_auth_state()
			end,
			auth_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_MANAGER] Auth screen created")

				components.auth_screen:set_state_text("Signing up")

				local current_omginstance = components.client_state:get_omginstance()
				if current_omginstance then
					print(os.date() .. " [CLIENT_MANAGER] Reset omginstance")

					current_omginstance:reset()
				else
					print(os.date() .. " [CLIENT_MANAGER] Create a new omginstance")

					local configuration
					if sys.get_engine_info().is_debug then
						configuration = require("project.connections.local_server")
						print(os.date() .. " [CLIENT_MANAGER] Use local server configuration")
						pprint(configuration)
					else
						error("[CLIENT_MANAGER] Only local server is supported")
					end

					current_omginstance = omginstance_factory:create(components, configuration)
					components.client_state:set_omginstance(current_omginstance)
				end

				current_omginstance:ping()
				current_omginstance:sign_up()
			end,
			signed_up = function(instance, components, event)
				local user_id = event.user_id
				local password = event.password

				print(os.date() .. " [CLIENT_MANAGER] Signed up, user_id=" .. tostring(user_id))

				components.auth_screen:set_state_text("Signing in")
				components.client_state:get_omginstance():sign_in(user_id, password)
			end,
			signed_in = function(instance, components, event)
				local client_id = event.client_id
				print(os.date() .. " [CLIENT_MANAGER] Signed in, client_id=" .. tostring(client_id))
				components.client_state:set_client_id(client_id)
			end,
			greeted = function(instance, components, event)
				local version_id = event.version_id
				local version_created = event.version_created
				print(os.date() .. " [CLIENT_MANAGER] Greeted, version_id=" .. tostring(version_id) .. ", version_created=" .. tostring(version_created))

				components.auth_screen:set_state_text("Getting profile")
				components.client_state:set_getting_profile_state()

				local game_message = game_messages:request_profile()
				local current_omginstance = components.client_state:get_omginstance()
				send_service_message(current_omginstance, game_message)
			end,
			server_message_received = function(instance, components, event)
				local decoded_message = event.decoded_message
				local message_qualifier = decoded_message.qualifier

				if message_qualifier == server_messages.SET_PROFILE then
					local profile = decoded_message.profile
					print(os.date() .. " [CLIENT_MANAGER] Set profile")

					components.client_state:set_profile(profile)

					local new_game_event = game_events:profile_updated()
					components.game_events:add_event(new_game_event)

				elseif message_qualifier == server_messages.SET_STATE then
					local settings = decoded_message.settings
					local state = decoded_message.state
					local step = decoded_message.step

					print(os.date() .. " [CLIENT_MANAGER] Set state, step=" .. tostring(step))

					components.match_state:set_state(settings, state, step)

					local new_game_event = game_events:state_received()
					components.game_events:add_event(new_game_event)

				elseif message_qualifier == server_messages.PLAY_EVENTS then
					local events = decoded_message.events
					local new_game_event = game_events:events_received(events)
					components.game_events:add_event(new_game_event)

				else
					error("[CLIENT_MANAGER] Unknown message qualifier was received, message_qualifier=" .. tostring(message_qualifier))
				end
			end,
			lobby_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_MANAGER] Lobby screen created")
				components.client_state:set_in_lobby_state()
			end,
			joining_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_MANAGER] Joining screen created")
				components.client_state:set_joining_state()
				components.joining_screen:set_state_text("Matchmaking")

				local nickname = components.client_state:get_nickname()
				local game_message = game_messages:request_matchmaking(nickname)
				local current_omginstance = components.client_state:get_omginstance()
				send_service_message(current_omginstance, game_message)
			end,
			connection_dispatched = function(instance, components, event)
				print(os.date() .. " [CLIENT_MANAGER] Connection dispatched")
				components.client_state:set_getting_state_state()

				local game_message = game_messages:request_state()
				local current_omginstance = components.client_state:get_omginstance()
				send_game_message(current_omginstance, game_message)
			end,
			match_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_MANAGER] Match screen created")
				components.client_state:set_in_match_state()

				print(os.date() .. " [CLIENT_MANAGER] Requesting player spawn")
				local game_message = game_messages:request_spawn()
				local current_omginstance = components.client_state:get_omginstance()
				send_game_message(current_omginstance, game_message)
			end,
			client_failed = function(instance, components, event)
				print(os.date() .. " [CLIENT_MANAGER] Client failed")
				components.client_state:set_game_failed_state()
			end,
			update = function(instance, dt, components)
				local current_omginstance = components.client_state:get_omginstance()
				if current_omginstance then
					current_omginstance:update(dt)
				end
			end
		}
	end
}

return client_manager