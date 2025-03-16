local defold_match_gui = require("project.defold.match_gui.match_gui")

local match_timer
match_timer = {
	-- Methods
	create = function(self)
		return {
			qualifier = "match_timer",
			predicate = function(instance, components)
				if not components.entrypoint_state:is_client_mode() then
					return
				end

				if not components.screen_state:is_match_screen() then
					return
				end
				
				return true
			end,
			events_received = function(instance, components, event)
				print(os.date() .. " [MATCH_TIMER] Event received")
				local match_gui_url = components.screen_state:get_match_gui_url()
				if match_gui_url then
					local step_interval = components.match_state.get_settings().step_interval
					defold_match_gui:reset_progress_bar(match_gui_url, step_interval)
				end
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return match_timer