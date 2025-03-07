local omginstance_factory = require("project.utils.omginstance_factory")
local server_messages = require("project.messages.server_messages")
local game_messages = require("project.messages.game_messages")
local client_events = require("project.messages.client_events")

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
			update = function(instance, dt, components)
				local current_omginstance = components.client_state:get_omginstance()
				if current_omginstance then
					current_omginstance:update(dt)
				end
				
				-- Handle game events
				local game_events = components.game_events:get_events()
				for i = 1,#game_events do
					local game_event = game_events[i]
					local game_event_id = game_event.id

					if game_event_id == client_events.CLIENT_STARTED then
						print(os.date() .. " [CLIENT_MANAGER] Client started")
						components.client_state:set_in_auth_state()

					elseif game_event_id == client_events.AUTH_SCREEN_CREATED then
						print(os.date() .. " [CLIENT_MANAGER] Auth screen created")

						components.auth_screen:set_state_text("Signing up")
						
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

					elseif game_event_id == client_events.SIGNED_UP then
						
						local user_id = game_event.user_id
						local password = game_event.password
						
						print(os.date() .. " [CLIENT_MANAGER] Signed up, user_id=" .. tostring(user_id))

						components.auth_screen:set_state_text("Signing in")
						current_omginstance:sign_in(user_id, password)
					
					elseif game_event_id == client_events.SIGNED_IN then
						local client_id = game_event.client_id
						print(os.date() .. " [CLIENT_MANAGER] Signed in, client_id=" .. tostring(client_id))
						components.client_state:set_client_id(client_id)

					elseif game_event_id == client_events.GREETED then
						local version_id = game_event.version_id
						local version_created = game_event.version_created
						print(os.date() .. " [CLIENT_MANAGER] Greeted, version_id=" .. tostring(version_id) .. ", version_created=" .. tostring(version_created))
						
						components.auth_screen:set_state_text("Getting profile")
						components.client_state:set_getting_profile_state()

						local game_message = game_messages:request_profile()
						send_service_message(current_omginstance, game_message)

					elseif game_event_id == client_events.MESSAGE_RECEIVED then
						local decoded_message = game_event.decoded_message
						local message_qualifier = decoded_message.qualifier
						
						if message_qualifier == server_messages.SET_PROFILE then
							local profile = decoded_message.profile
							print(os.date() .. " [CLIENT_MANAGER] Set profile")

							components.client_state:set_profile(profile)

							local new_game_event = client_events:profile_updated()
							components.game_events:add_event(new_game_event)

						elseif message_qualifier == server_messages.SET_STATE then
							local settings = decoded_message.settings
							local state = decoded_message.state
							local step = decoded_message.step

							print(os.date() .. " [CLIENT_MANAGER] Set state, step=" .. tostring(step))

							components.match_state:set_state(settings, state, step)
							
							local new_game_event = client_events:state_received()
							components.game_events:add_event(new_game_event)

						elseif message_qualifier == server_messages.PLAY_EVENTS then
							local events = decoded_message.events
							local new_game_event = client_events:events_received(events)
							components.game_events:add_event(new_game_event)

						else
							error("[CLIENT_MANAGER] Unknown message qualifier was received, message_qualifier=" .. tostring(message_qualifier))
						end
						
					elseif game_event_id == client_events.LOBBY_SCREEN_CREATED then
						print(os.date() .. " [CLIENT_MANAGER] Lobby screen created")
						components.client_state:set_in_lobby_state()

					elseif game_event_id == client_events.JOINING_SCREEN_CREATED then
						print(os.date() .. " [CLIENT_MANAGER] Joining screen created")
						components.client_state:set_joining_state()
						components.joining_screen:set_state_text("Matchmaking")

						local nickname = components.client_state:get_nickname()
						local game_message = game_messages:request_matchmaking(nickname)
						send_service_message(current_omginstance, game_message)

					elseif game_event_id == client_events.CONNECTION_DISPATCHED then
						print(os.date() .. " [CLIENT_MANAGER] Connection dispatched")
						components.client_state:set_getting_state_state()

						local game_message = game_messages:request_state()
						send_game_message(current_omginstance, game_message)

					elseif game_event_id == client_events.MATCH_SCREEN_CREATED then
						print(os.date() .. " [CLIENT_MANAGER] Match screen created")
						components.client_state:set_in_match_state()

						print(os.date() .. " [CLIENT_MANAGER] Requesting player spawn")
						local game_message = game_messages:request_spawn()
						send_game_message(current_omginstance, game_message)
						
					elseif game_event_id == client_events.CLIENT_FAILED then
						print(os.date() .. " [CLIENT_MANAGER] Client failed")
						components.client_state:set_game_failed_state()

					end
				end
			end
		}
	end
}

return client_manager