local omgruntime_factory = require("project.module.omgruntime_factory")

local server_root
server_root = {
	create = function(self)
		return {
			qualifier = "server_root",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_server_mode() then
					return
				end

				return true
			end,
			server_started = function(instance, components, event)
				print(os.date() .. " [SERVER_ROOT] Server started")

				local current_omgruntime = omgruntime_factory:create(components)
				components.server.state:set_omgruntime(current_omgruntime)
			end,
			runtime_started = function(instance, components, event)
				local runtime_qualifier = event.runtime_qualifier
				components.server.state:set_runtime_qualifier(runtime_qualifier)
			end,
			update = function(instance, dt, components)
				local current_omgruntime = components.server.state:get_omgruntime()
				if current_omgruntime then
					current_omgruntime:update(dt)
				end
			end
		}
	end
}

return server_root