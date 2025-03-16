local game_events = require("project.message.game_events")
local omgruntime = require("omgservers.omgruntime.omgruntime")

local omgruntime_factory
omgruntime_factory = {
	DEBUG = false,
	-- Methods
	create = function(self, components, configuration)
		local options = {
			event_handler = function(server_event)
				if omgruntime_factory.DEBUG then
					print(os.date() .. " [OMGRUNTIME_FACTORY] Server event was received, event=" .. json.encode(server_event))
				end

				local event_qualifier = server_event.qualifier
				local event_body = server_event.body

				if event_qualifier == omgruntime.constants.SERVER_STARTED then
					local runtime_qualifier = event_body.runtime_qualifier
					local new_game_event = game_events:runtime_started(runtime_qualifier)
					components.shared.events:add_event(new_game_event)

				elseif event_qualifier == omgruntime.constants.COMMAND_RECEIVED then
					local command_qualifier = event_body.qualifier
					local command_body = event_body.body
					local new_game_event = game_events:command_received(command_qualifier, command_body)
					components.shared.events:add_event(new_game_event)

				elseif event_qualifier == omgruntime.constants.MESSAGE_RECEIVED then
					local client_id = event_body.client_id
					local decoded_message = json.decode(event_body.message)
					local new_game_event = game_events:client_message_received(client_id, decoded_message)
					components.shared.events:add_event(new_game_event)

				else
					print("[OMGRUNTIME_FACTORY] Unknown server event was received, event_qualifier=" .. tostring(event_qualifier))
				end
			end,
			debug_logging = true,
			trace_logging = false,
		}		
		omgruntime:init(options)
		omgruntime:start()

		return omgruntime
	end
}

return omgruntime_factory