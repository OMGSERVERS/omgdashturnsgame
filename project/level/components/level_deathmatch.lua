local level_deathmatch
level_deathmatch = {
	QUEUEING = "queueing",
	SIMULATION = "simulation",
	-- Methods
	create = function(self)
		local state = level_deathmatch.QUEUEING
		local movements = 0
		
		return {
			qualifier = "level_deathmatch",
			-- Methods
			set_queueing_state = function(instance)
				print(os.date() .. " [LEVEL_DEATHMATCH] Set state -> " .. level_deathmatch.QUEUEING)
				state = level_deathmatch.QUEUEING
			end,
			is_queueing_state = function(instance)
				return state == level_deathmatch.QUEUEING
			end,
			set_simulation_state = function(instance)
				print(os.date() .. " [LEVEL_DEATHMATCH] Set state -> " .. level_deathmatch.SIMULATION)
				state = level_deathmatch.SIMULATION
			end,
			is_simulation_state = function(instance)
				return state == level_deathmatch.SIMULATION
			end,
			increase_movements = function(instance)
				movements = movements + 1
			end,
			decrease_movements = function(instance)
				movements = movements - 1
			end,
			are_movements_finished = function(instance)
				return movements == 0
			end,
		}
	end
}

return level_deathmatch