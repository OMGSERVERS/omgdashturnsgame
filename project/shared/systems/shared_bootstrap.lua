local game_events = require("project.message.game_events")

local shared_bootstrap
shared_bootstrap = {
	create = function(self)
		return {
			qualifier = "shared_bootstrap",
			predicate = function(instance, components)
				if components.shared.bootstrap:is_mode_set() then
					return
				end
				
				return true
			end,
			update = function(instance, dt, components)
				print(os.date() .. " [SHARED_BOOTSTRAP] Engine info:")
				pprint(sys.get_engine_info())

				if os.getenv("SERVER_ENVIRONMENT") then
					components.shared.bootstrap:set_server_mode()
					local new_event = game_events:server_started()
					components.shared.events:add_event(new_event)
				else
					components.shared.bootstrap:set_client_mode()
					local new_event = game_events:client_started()
					components.shared.events:add_event(new_event)
				end
			end
		}
	end
}

return shared_bootstrap