local shared_level
shared_level = {
	FOREST_LEVEL = "forest_level",
	-- Methods
	create = function(self)
		local qualifier = nil
		local wrapped_level = nil
		local bounds = nil
		local spawn_points = {}
		
		return {
			qualifier = "shared_level",
			-- Methods
			get_level_qualifier = function(instance)
				return qualifier
			end,
			get_wrapped_level = function(instance)
				return wrapped_level
			end,
			reset_component = function(instance)
				qualifier = nil
				wrapped_level = nil
				bounds = nil
				spawn_points = {}
			end,
			setup_level = function(instance, level_qualifier, level_wrapped_level, level_bounds, level_spawn_points)
				print(os.date() .. " [SHARED_LEVEL] Setup level, spawn_points=" .. #level_spawn_points)
				qualifier = level_qualifier
				wrapped_level = level_wrapped_level
				bounds = level_bounds
				spawn_points = level_spawn_points
			end,
			get_level_bounds = function(instance)
				return bounds
			end,
			get_random_spawn_position = function(instance)
				if spawn_points then
					return spawn_points[math.random(#spawn_points)]
				end
			end,
		}
	end
}

return shared_level