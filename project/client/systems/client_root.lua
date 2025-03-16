local omginstance_factory = require("project.module.omginstance_factory")
local server_messages = require("project.message.server_messages")
local game_messages = require("project.message.game_messages")
local game_events = require("project.message.game_events")

local client_root
client_root = {
	create = function(self)

		local send_service_message = function(omginstance, message)
			local encoded_message = json.encode(message)
			omginstance:send_service_message(encoded_message)
		end

		local send_game_message = function(omginstance, message)
			omginstance:send_binary_message(json.encode(message))
		end
		
		return {
			qualifier = "client_root",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_client_mode() then
					return
				end

				return true
			end,
			client_started = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Client started")
				components.client.state:set_in_auth_state()
			end,
			auth_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Auth screen created")

				components.screen.auth:set_state_text("Signing up")

				local current_omginstance = components.client.state:get_omginstance()
				if current_omginstance then
					print(os.date() .. " [CLIENT_ROOT] Reset omginstance")

					current_omginstance:reset()
				else
					print(os.date() .. " [CLIENT_ROOT] Create a new omginstance")

					local configuration
					if sys.get_engine_info().is_debug then
						configuration = require("project.connection.local_server")
						print(os.date() .. " [CLIENT_ROOT] Use local server configuration")
						pprint(configuration)
					else
						error("[CLIENT_ROOT] Only local server is supported")
					end

					current_omginstance = omginstance_factory:create(components, configuration)
					components.client.state:set_omginstance(current_omginstance)
				end

				current_omginstance:ping()
				current_omginstance:sign_up()
			end,
			signed_up = function(instance, components, event)
				local user_id = event.user_id
				local password = event.password

				print(os.date() .. " [CLIENT_ROOT] Signed up, user_id=" .. tostring(user_id))

				components.screen.auth:set_state_text("Signing in")
				components.client.state:get_omginstance():sign_in(user_id, password)
			end,
			signed_in = function(instance, components, event)
				local client_id = event.client_id
				print(os.date() .. " [CLIENT_ROOT] Signed in, client_id=" .. tostring(client_id))
				components.client.state:set_client_id(client_id)
			end,
			greeted = function(instance, components, event)
				local version_id = event.version_id
				local version_created = event.version_created
				print(os.date() .. " [CLIENT_ROOT] Greeted, version_id=" .. tostring(version_id) .. ", version_created=" .. tostring(version_created))

				components.screen.auth:set_state_text("Getting profile")
				components.client.state:set_getting_profile_state()

				local game_message = game_messages:request_profile()
				local current_omginstance = components.client.state:get_omginstance()
				send_service_message(current_omginstance, game_message)
			end,
			server_message_received = function(instance, components, event)
				local decoded_message = event.decoded_message
				local message_qualifier = decoded_message.qualifier

				if message_qualifier == server_messages.SET_PROFILE then
					local profile = decoded_message.profile
					print(os.date() .. " [CLIENT_ROOT] Set profile")

					components.client.state:set_profile(profile)

					local new_game_event = game_events:profile_updated()
					components.shared.events:add_event(new_game_event)

				elseif message_qualifier == server_messages.SET_STATE then
					local settings = decoded_message.settings
					local state = decoded_message.state
					local step = decoded_message.step

					print(os.date() .. " [CLIENT_ROOT] Set state, step=" .. tostring(step))

					components.shared.state:set_state(settings, state, step)

					local new_game_event = game_events:state_received()
					components.shared.events:add_event(new_game_event)

				elseif message_qualifier == server_messages.PLAY_EVENTS then
					local events = decoded_message.events
					local new_game_event = game_events:events_received(events)
					components.shared.events:add_event(new_game_event)
					
				else
					error("[CLIENT_ROOT] Unknown message qualifier was received, message_qualifier=" .. tostring(message_qualifier))
				end
			end,
			lobby_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Lobby screen created")
				components.client.state:set_in_lobby_state()
			end,
			joining_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Joining screen created")
				components.client.state:set_joining_state()
				components.screen.joining:set_state_text("Matchmaking")

				local nickname = components.client.state:get_nickname()
				local game_message = game_messages:request_matchmaking(nickname)
				local current_omginstance = components.client.state:get_omginstance()
				send_service_message(current_omginstance, game_message)
			end,
			leaving_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Leaving screen created")
				components.client.state:set_leaving_state()
				components.screen.leaving:set_state_text("Leaving")

				local game_message = game_messages:request_leave()
				local current_omginstance = components.client.state:get_omginstance()
				send_game_message(current_omginstance, game_message)
			end,
			connection_dispatched = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Connection dispatched")
				components.client.state:set_getting_state_state()

				local game_message = game_messages:request_state()
				local current_omginstance = components.client.state:get_omginstance()
				send_game_message(current_omginstance, game_message)
			end,
			match_screen_created = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Match screen created")
				components.client.state:set_in_match_state()

				print(os.date() .. " [CLIENT_ROOT] Requesting player spawn")
				local game_message = game_messages:request_spawn()
				local current_omginstance = components.client.state:get_omginstance()
				send_game_message(current_omginstance, game_message)
			end,
			player_killed = function(instance, components, event)
				local killed_client_id = event.client_id
				local this_client_id = components.client.state:get_client_id()
				if killed_client_id == this_client_id then
					print(os.date() .. " [CLIENT_ROOT] Player killed, request spawn")
					local game_message = game_messages:request_spawn()
					local current_omginstance = components.client.state:get_omginstance()
					send_game_message(current_omginstance, game_message)
				end
			end,
			client_failed = function(instance, components, event)
				print(os.date() .. " [CLIENT_ROOT] Client failed")
				components.client.state:set_game_failed_state()
			end,
			pointer_placed = function(instance, components, event)
				local x = event.x
				local y = event.y
				print(os.date() .. " [CLIENT_ROOT] Pointer placed, x=" .. tostring(x) .. ", y=" .. tostring(y))
				local game_message = game_messages:request_move(x, y)
				local current_omginstance = components.client.state:get_omginstance()
				send_game_message(current_omginstance, game_message)
			end,
			update = function(instance, dt, components)
				local current_omginstance = components.client.state:get_omginstance()
				if current_omginstance then
					current_omginstance:update(dt)
				end
			end
		}
	end
}

return client_root