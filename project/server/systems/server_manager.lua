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
			server_started = function(instance, components, event)
				print(os.date() .. " [SERVER_MANAGER] Server started")

				local current_omgruntime = omgruntime_factory:create(components)
				components.server_state:set_omgruntime(current_omgruntime)
			end,
			runtime_started = function(instance, components, event)
				local runtime_qualifier = event.runtime_qualifier
				components.server_state:set_runtime_qualifier(runtime_qualifier)
			end,
			update = function(instance, dt, components)
				local current_omgruntime = components.server_state:get_omgruntime()
				if current_omgruntime then
					current_omgruntime:update(dt)
				end
			end
		}
	end
}

return server_manager