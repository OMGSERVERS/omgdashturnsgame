local server_events = require("project.messages.server_events")

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
			update = function(instance, dt, components)
				local simulator = components.match_simulator

				simulator:update_match_timer(dt)
				if simulator:is_match_over() then
					print(os.date() .. " [MATCH_SIMULATOR] Match is over")
					simulator:disable()

					local new_event = server_events:match_over()
					components.game_events:add_event(new_event)
				end

				simulator:update_step_timer(dt)
				if simulator:is_step_over() then
					simulator:reset_step_timer()
					local step_index = simulator:increase_step_index()

					local new_event = server_events:step_over(step_index)
					components.game_events:add_event(new_event)
				end
			end
		}
	end
}

return match_simulator