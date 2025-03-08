local game_events = require("project.messages.game_events")

local game_entrypoint
game_entrypoint = {
	create = function(self)
		return {
			qualifier = "game_entrypoint",
			predicate = function(instance, components)
				if components.entrypoint_state:is_mode_set() then
					return
				end
				
				return true
			end,
			update = function(instance, dt, components)
				print(os.date() .. " [GAME_ENTRYPOINT] Engine info:")
				pprint(sys.get_engine_info())

				if os.getenv("SERVER_ENVIRONMENT") then
					components.entrypoint_state:set_server_mode()
					local new_event = game_events:server_started()
					components.game_events:add_event(new_event)
				else
					components.entrypoint_state:set_client_mode()
					local new_event = game_events:client_started()
					components.game_events:add_event(new_event)
				end
			end
		}
	end
}

return game_entrypoint