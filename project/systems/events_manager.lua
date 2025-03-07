local events_manager
events_manager = {
	create = function(self)
		return {
			qualifier = "events_manager",
			predicate = function(instance, components)
				return true
			end,
			update = function(instance, dt, components)
				components.game_events:erase_events()
			end
		}
	end
}

return events_manager