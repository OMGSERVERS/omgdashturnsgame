local death_match
death_match = {
	QUEUEING = "queueing",
	SIMULATION = "simulation",
	-- Methods
	create = function(self)
		local state = death_match.QUEUEING
		
		return {
			qualifier = "death_match",
			-- Methods
			set_queueing_state = function(instance)
				print(os.date() .. " [DEATH_MATCH] Set state -> " .. death_match.QUEUEING)
				state = death_match.QUEUEING
			end,
			is_queueing_state = function(instance)
				return state == death_match.QUEUEING
			end,
			set_simulation_state = function(instance)
				print(os.date() .. " [DEATH_MATCH] Set state -> " .. death_match.SIMULATION)
				state = death_match.SIMULATION
			end,
			is_simulation_state = function(instance)
				return state == death_match.SIMULATION
			end,
		}
	end
}

return death_match