local server_messages = require("project.messages.server_messages")
local profile_wrapper = require("project.utils.profile_wrapper")
local game_messages = require("project.messages.game_messages")
local omgruntime = require("omgservers.omgruntime.omgruntime")
local server_events = require("project.messages.server_events")
local match_requests = require("project.messages.match_requests")

local match_runtime
match_runtime = {
	create = function(self)
		
		return {
			qualifier = "match_runtime",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_server_mode() then
					return
				end

				if not components.server_state:is_match_runtime() then
					return
				end

				return true
			end,
			update = function(instance, dt, components)
				local current_omgruntime = components.server_state:get_omgruntime()

				local game_events = components.game_events:get_events()
				for i = 1,#game_events do
					local game_event = game_events[i]
					local game_event_id = game_event.id

					if game_event_id == server_events.COMMAND_RECEIVED then
						local command_qualifier = game_event.command_qualifier
						local command_body = game_event.command_body

						if command_qualifier == omgruntime.constants.INIT_RUNTIME then
							print(os.date() .. " [MATCH_RUNTIME] Init runtime")
							local version_config = command_body.runtime_config.version_config
							components.match_runtime:set_config(version_config)
							components.match_simulator:enable()

							local settings = {
								level = server_messages.FOREST_LEVEL,
							}
							components.match_state:init_state(settings)

							local new_game_event = server_events:state_initialized()
							components.game_events:add_event(new_game_event)
							
						elseif command_qualifier == omgruntime.constants.ADD_MATCH_CLIENT then
							local client_id = command_body.client_id
							local profile = command_body.profile
							print(os.date() .. " [MATCH_RUNTIME] Add client, client_id=" .. tostring(client_id))

							local wrapped_profile = profile_wrapper:wrap(profile)
							components.match_runtime:add_profile(client_id, wrapped_profile)

							-- Makes client to use websockets
							current_omgruntime:upgrade_connection(client_id)

							local nickname = wrapped_profile.profile.data.nickname
							local match_request = match_requests:add_client(client_id, nickname, 0)
							components.match_runtime:add_request(match_request)
							
						elseif command_qualifier == omgruntime.constants.DELETE_CLIENT then
							local client_id = command_body.client_id
							print(os.date() .. " [MATCH_RUNTIME] Delete client, client_id=" .. tostring(client_id))
							components.match_runtime:delete_profile(client_id)

							local match_request = match_requests:delete_client(client_id)
							components.match_runtime:add_request(match_request)
							
						end
					elseif game_event_id == server_events.MESSAGE_RECEIVED then
						local client_id = game_event.client_id
						local decoded_message = game_event.decoded_message
						local message_qualifier = decoded_message.qualifier

						if message_qualifier == game_messages.REQUEST_STATE then
							local settings = components.match_state:get_settings()
							local state = components.match_state:get_state()
							local step = components.match_state:get_step()

							local server_message = server_messages:set_state(settings, state, step)
							current_omgruntime:respond_binary_message(client_id, json.encode(server_message))

							print(os.date() .. " [MATCH_RUNTIME] State is sent, client_id=" .. tostring(client_id))

						elseif message_qualifier == game_messages.REQUEST_LEAVE then
							print(os.date() .. " [MATCH_RUNTIME] Request leave, client_id=" .. tostring(client_id))
							current_omgruntime:kick_client(client_id)

						elseif message_qualifier == game_messages.REQUEST_SPAWN then
							print(os.date() .. " [MATCH_RUNTIME] Request spawn, client_id=" .. tostring(client_id))

							local match_request = match_requests:spawn_player(client_id)
							components.match_runtime:add_request(match_request)

						elseif message_qualifier == game_messages.REQUEST_MOVE then
							print(os.date() .. " [MATCH_RUNTIME] Request move, client_id=" .. tostring(client_id))
							local x = decoded_message.x
							local y = decoded_message.y

							local match_request = match_requests:move_player(client_id, x, y)
							components.match_runtime:add_request(match_request)

						else
							print(os.date() .. " [MATCH_RUNTIME] Unknown message qualifier was received, message_qualifier=" .. tostring(message_qualifier))
						end

					elseif game_event_id == server_events.STEP_SIMULATED then
						local events = game_event.events
						print(os.date() .. " [MATCH_RUNTIME] Step is simulated, " .. #events .. " events to send")
						local server_message = server_messages:play_events(events)
						omgruntime:broadcast_binary_message(json.encode(server_message))
						
					elseif game_event_id == server_events.MATCH_OVER then
						print(os.date() .. " [MATCH_RUNTIME] Match is over")
						current_omgruntime:stop_matchmaking()

					end
				end
			end
		}
	end
}

return match_runtime