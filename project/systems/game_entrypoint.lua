local client_events = require("project.messages.client_events")
local server_events = require("project.messages.server_events")

local game_entrypoint
game_entrypoint = {
	create = function(self)
		return {
			qualifier = "game_entrypoint",
			update = function(instance, dt, components)
				local is_mode_set = components.entrypoint_state:is_mode_set()
				if not is_mode_set then
					print(os.date() .. " [GAME_ENTRYPOINT] Engine info:")
					pprint(sys.get_engine_info())

					if os.getenv("SERVER_ENVIRONMENT") then
						components.entrypoint_state:set_server_mode()
						local new_event = server_events:server_started()
						components.game_events:add_event(new_event)
					else
						components.entrypoint_state:set_client_mode()
						local new_event = client_events:client_started()
						components.game_events:add_event(new_event)
					end
				end
			end
		}
	end
}

return game_entrypoint