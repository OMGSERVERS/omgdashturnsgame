local physics_listener = require("project.module.physics_listener")
local game_events = require("project.message.game_events")

local server_simulator_system
server_simulator_system = {
	create = function(self)
		
		return {
			qualifier = "server_simulator_system",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_server_mode() then
					return
				end

				if not components.server_state:is_match_runtime() then
					return
				end

				if not components.match_simulator:is_enabled() then
					return
				end

				return true
			end,
			level_created = function(instance, components, event)
				print(os.date() .. " [SERVER_SIMULATOR_SYSTEM] Level created, set physics listener")
				physics.set_listener(physics_listener:create(components))
			end,
			level_deleted = function(instance, components, event)
				print(os.date() .. " [SERVER_SIMULATOR_SYSTEM] Level deleted, delete physics listener")
				physics.set_listener(nil)
			end,
			step_simulated = function(instance, components, event)
				print(os.date() .. " [SERVER_SIMULATOR_SYSTEM] Step simulated")
				components.match_simulator:set_queueing_state()
				components.match_simulator:reset_step_timer()
			end,
			update = function(instance, dt, components)
				if components.match_simulator:is_queueing_state() then
					components.match_simulator:update_step_timer(dt)

					if components.match_simulator:is_step_over() then
						local step_index = components.match_simulator:increase_step_index()
						components.match_simulator:set_simulation_state()

						local new_event = game_events:step_over(step_index)
						components.game_events:add_event(new_event)
					end
				end

				components.match_simulator:update_match_timer(dt)
				if components.match_simulator:is_match_over() then
					print(os.date() .. " [SERVER_SIMULATOR_SYSTEM] Match is over")
					components.match_simulator:disable()

					local new_event = game_events:match_over()
					components.game_events:add_event(new_event)
				end
			end
		}
	end
}

return server_simulator_system