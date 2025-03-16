local level_deathmatch
level_deathmatch = {
	
	-- Methods
	create = function(self)
		
		local movements = 0
		
		return {
			qualifier = "level_deathmatch",
			-- Methods
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