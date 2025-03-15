local match_simulator
match_simulator = {
	MATCH_LIFETIME = 256,
	STEP_INTERVAL = 2,
	-- Methods
	create = function(self)
		local enabled = false
		local match_timer = 0
		local step_timer = 0
		local step_index = 1
		local simulation = false
		
		return {
			qualifier = "match_simulator",
			-- Methods
			get_step_interval = function(instance)
				return match_simulator.STEP_INTERVAL
			end,
			enable = function(instance)
				enabled = true
				match_timer = 0
				step_timer = 0
				step_index = 1
				simulation = false
			end,
			disable = function(instance)
				enabled = false
			end,
			is_enabled = function(instance)
				return enabled
			end,
			get_match_timer = function(instance)
				return match_timer
			end,
			update_match_timer = function(instance, dt)
				match_timer = match_timer + dt
			end,
			is_match_over = function(instance)
				return match_timer > match_simulator.MATCH_LIFETIME
			end,
			get_step_timer = function(instance)
				return step_timer
			end,
			reset_step_timer = function(instance, timer)
				step_timer = 0
			end,
			update_step_timer = function(instance, dt)
				step_timer = step_timer + dt
			end,
			is_step_over = function(instance)
				return step_timer > match_simulator.STEP_INTERVAL
			end,
			get_step_index = function(instance)
				return step_index
			end,
			increase_step_index = function(instance)
				local prev_step = step_index
				step_index = step_index + 1
				return prev_step
			end,
			is_simulation = function(instance)
				return simulation
			end,
			set_simulation = function(instance, value)
				simulation = value
			end,
		}
	end
}

return match_simulator