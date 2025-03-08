local omgruntime_factory = require("project.utils.omgruntime_factory")
local game_events = require("project.messages.game_events")

local server_manager
server_manager = {
	create = function(self)
		return {
			qualifier = "server_manager",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_server_mode() then
					return
				end

				return true
			end,
			update = function(instance, dt, components)
				local current_omgruntime = components.server_state:get_omgruntime()
				if current_omgruntime then
					current_omgruntime:update(dt)
				end
				
				local events = components.game_events:get_events()
				for i = 1,#events do
					local game_event = events[i]
					local game_event_id = game_event.id
					if game_event_id == game_events.SERVER_STARTED then
						print(os.date() .. " [SERVER_MANAGER] Server started")

						current_omgruntime = omgruntime_factory:create(components)
						components.server_state:set_omgruntime(current_omgruntime)

					elseif game_event_id == game_events.RUNTIME_STARTED then
						local runtime_qualifier = game_event.runtime_qualifier
						components.server_state:set_runtime_qualifier(runtime_qualifier)
						
					end
				end
			end
		}
	end
}

return server_manager