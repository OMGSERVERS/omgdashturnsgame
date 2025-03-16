local server_simulator
server_simulator = {
	MATCH_LIFETIME = 256,
	STEP_INTERVAL = 2,
	SIMULATION_INTERVAL = 1,
	QUEUEING_STATE = "queueing",
	SIMULATION_STATE = "simulation",
	-- Methods
	create = function(self)
		local enabled = false
		local state = server_simulator.QUEUEING_STATE
		local match_timer = 0
		local step_timer = 0
		local step_index = 1
		local simulation_timer = 0
		
		return {
			qualifier = "server_simulator",
			-- Methods
			get_step_interval = function(instance)
				return server_simulator.STEP_INTERVAL
			end,
			setup_simulator = function(instance)
				enabled = true
				state = server_simulator.QUEUEING_STATE
				match_timer = 0
				step_timer = 0
				step_index = 1
				simulation_timer = 0
			end,
			is_enabled = function(instance)
				return enabled
			end,
			disable = function(instance)
				enabled = false
			end,
			set_queueing_state = function(instance)
				state = server_simulator.QUEUEING_STATE
				print(os.date() .. " [SERVER_SIMULATOR] Set state -> " .. tostring(state))
			end,
			is_queueing_state = function(instance)
				return state == server_simulator.QUEUEING_STATE
			end,
			set_simulation_state = function(instance)
				state = server_simulator.SIMULATION_STATE
				print(os.date() .. " [SERVER_SIMULATOR] Set state -> " .. state)
			end,
			is_simulation_state = function(instance)
				return state == server_simulator.SIMULATION_STATE
			end,
			get_match_timer = function(instance)
				return match_timer
			end,
			update_match_timer = function(instance, dt)
				match_timer = match_timer + dt
			end,
			is_match_over = function(instance)
				return match_timer > server_simulator.MATCH_LIFETIME
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
				return step_timer > server_simulator.STEP_INTERVAL
			end,
			get_step_index = function(instance)
				return step_index
			end,
			increase_step_index = function(instance)
				local prev_step = step_index
				step_index = step_index + 1
				return prev_step
			end,
			get_simulation_timer = function(instance)
				return simulation_timer
			end,
			reset_simulation_timer = function(instance, timer)
				simulation_timer = 0
			end,
			update_simulation_timer = function(instance, dt)
				simulation_timer = simulation_timer+ dt
			end,
			is_simulation_over = function(instance)
				return simulation_timer > server_simulator.SIMULATION_INTERVAL
			end,
		}
	end
}

return server_simulator