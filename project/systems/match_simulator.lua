local physics_listener = require("project.utils.physics_listener")
local game_events = require("project.messages.game_events")

local match_simulator
match_simulator = {
	create = function(self)
		
		return {
			qualifier = "match_simulator",
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
				print(os.date() .. " [MATCH_SCREEN] Level created, set physics listener")
				physics.set_listener(physics_listener:create(components))
			end,
			leave_pressed = function(instance, components, event)
				print(os.date() .. " [MATCH_CAMERA] Leave pressed, delete physics listener")
				physics.set_listener(nil)
			end,
			step_simulated = function(instance, components, event)
				components.match_simulator:set_simulation(false)
				components.match_simulator:reset_step_timer()
			end,
			update = function(instance, dt, components)
				local simulator = components.match_simulator

				simulator:update_match_timer(dt)
				if simulator:is_match_over() then
					print(os.date() .. " [MATCH_SIMULATOR] Match is over")
					simulator:disable()

					local new_event = game_events:match_over()
					components.game_events:add_event(new_event)
				end

				if not simulator:is_simulation() then
					simulator:update_step_timer(dt)
					
					if simulator:is_step_over() then
						local step_index = simulator:increase_step_index()
						simulator:set_simulation(true)

						local new_event = game_events:step_over(step_index)
						components.game_events:add_event(new_event)
					end
				end
			end
		}
	end
}

return match_simulator