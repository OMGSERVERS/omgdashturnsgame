local physics_listener = require("project.module.physics_listener")
local game_events = require("project.message.game_events")

local server_simulator
server_simulator = {
	create = function(self)
		
		return {
			qualifier = "server_simulator",
			predicate = function(instance, components)
				if not components.shared.bootstrap:is_server_mode() then
					return
				end

				if not components.server.state:is_match_runtime() then
					return
				end

				return true
			end,
			level_created = function(instance, components, event)
				print(os.date() .. " [SERVER_SIMULATOR] Level created, set physics listener")
				physics.set_listener(physics_listener:create(components))
			end,
			level_deleted = function(instance, components, event)
				print(os.date() .. " [SERVER_SIMULATOR] Level deleted, delete physics listener")
				physics.set_listener(nil)
			end,
			update = function(instance, dt, components)
				if components.server.simulator:is_queueing_state() then
					components.server.simulator:update_step_timer(dt)

					if components.server.simulator:is_step_over() then
						local step_index = components.server.simulator:increase_step_index()
						components.server.simulator:set_simulation_state()
						components.server.simulator:reset_simulation_timer()

						local new_event = game_events:step_over(step_index)
						components.shared.events:add_event(new_event)
					end
				end

				if components.server.simulator:is_simulation_state() then
					components.server.simulator:update_simulation_timer(dt)

					if components.server.simulator:is_simulation_over() then
						components.server.simulator:set_queueing_state()
						components.server.simulator:reset_step_timer()

						local step_events = components.shared.state:get_events()
						local new_game_event = game_events:step_simulated(step_events)
						components.shared.events:add_event(new_game_event)
					end
				end

				if not components.server.simulator:is_shutting_down() then
					components.server.simulator:update_match_timer(dt)
					
					if components.server.simulator:is_match_over() then
						print(os.date() .. " [SERVER_SIMULATOR] Match is over, shutting down")
						components.server.simulator:shutdown()

						local new_event = game_events:match_over()
						components.shared.events:add_event(new_event)
					end
				end
			end
		}
	end
}

return server_simulator