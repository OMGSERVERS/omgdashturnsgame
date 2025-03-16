local server_messages = require("project.message.server_messages")
local profile_wrapper = require("project.module.profile_wrapper")
local game_messages = require("project.message.game_messages")
local omgruntime = require("omgservers.omgruntime.omgruntime")
local game_events = require("project.message.game_events")
local match_requests = require("project.message.match_requests")

local server_match_system
server_match_system = {
	create = function(self)
		return {
			qualifier = "server_match_system",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_server_mode() then
					return
				end

				if not components.server_state:is_match_runtime() then
					return
				end

				return true
			end,
			command_received = function(instance, components, event)
				local command_qualifier = event.command_qualifier
				local command_body = event.command_body

				local current_omgruntime = components.server_state:get_omgruntime()
				
				if command_qualifier == omgruntime.constants.INIT_RUNTIME then
					print(os.date() .. " [SERVER_MATCH_SYSTEM] Init runtime")
					local version_config = command_body.runtime_config.version_config
					components.match_runtime:set_config(version_config)
					components.match_simulator:setup_simulator()

					local settings = {
						match_level = server_messages.FOREST_LEVEL,
						step_interval = components.match_simulator:get_step_interval(),
					}
					components.match_state:init_state(settings)

					local new_game_event = game_events:state_initialized()
					components.game_events:add_event(new_game_event)

				elseif command_qualifier == omgruntime.constants.ADD_MATCH_CLIENT then
					local client_id = command_body.client_id
					local profile = command_body.profile
					print(os.date() .. " [SERVER_MATCH_SYSTEM] Add client, client_id=" .. tostring(client_id))

					local wrapped_profile = profile_wrapper:wrap(profile)
					components.match_runtime:add_profile(client_id, wrapped_profile)

					-- Makes client to use websockets
					current_omgruntime:upgrade_connection(client_id)

					local nickname = wrapped_profile.profile.data.nickname
					local match_request = match_requests:add_client(client_id, nickname, 0)
					components.match_runtime:add_request(match_request)

				elseif command_qualifier == omgruntime.constants.DELETE_CLIENT then
					local client_id = command_body.client_id
					print(os.date() .. " [SERVER_MATCH_SYSTEM] Delete client, client_id=" .. tostring(client_id))
					components.match_runtime:delete_profile(client_id)

					local match_request = match_requests:delete_client(client_id)
					components.match_runtime:add_request(match_request)

				end
			end,
			client_message_received = function(instance, components, event)
				local client_id = event.client_id
				local decoded_message = event.decoded_message
				local message_qualifier = decoded_message.qualifier

				local current_omgruntime = components.server_state:get_omgruntime()
				
				if message_qualifier == game_messages.REQUEST_STATE then
					local settings = components.match_state:get_settings()
					local state = components.match_state:get_state()
					local step = components.match_state:get_step()

					local server_message = server_messages:set_state(settings, state, step)
					current_omgruntime:respond_binary_message(client_id, json.encode(server_message))

					print(os.date() .. " [SERVER_MATCH_SYSTEM] State is sent, client_id=" .. tostring(client_id))

				elseif message_qualifier == game_messages.REQUEST_LEAVE then
					print(os.date() .. " [SERVER_MATCH_SYSTEM] Request leave, client_id=" .. tostring(client_id))
					current_omgruntime:kick_client(client_id)

				elseif message_qualifier == game_messages.REQUEST_SPAWN then
					print(os.date() .. " [SERVER_MATCH_SYSTEM] Request spawn, client_id=" .. tostring(client_id))

					local match_request = match_requests:spawn_player(client_id)
					components.match_runtime:add_request(match_request)

				elseif message_qualifier == game_messages.REQUEST_MOVE then
					print(os.date() .. " [SERVER_MATCH_SYSTEM] Request move, client_id=" .. tostring(client_id))
					local x = decoded_message.x
					local y = decoded_message.y

					local match_request = match_requests:move_player(client_id, x, y)
					components.match_runtime:add_request(match_request)

				else
					print(os.date() .. " [SERVER_MATCH_SYSTEM] Unknown message qualifier was received, message_qualifier=" .. tostring(message_qualifier))
				end
			end,
			step_simulated = function(instance, components, event)
				local step_events = event.events
				print(os.date() .. " [SERVER_MATCH_SYSTEM] Step is simulated, " .. #step_events .. " events to send")
				local server_message = server_messages:play_events(step_events)
				omgruntime:broadcast_binary_message(json.encode(server_message))
			end,
			match_over = function(instance, components, event)
				print(os.date() .. " [SERVER_MATCH_SYSTEM] Match is over")
				components.server_state:get_omgruntime():stop_matchmaking()
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return server_match_system