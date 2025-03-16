local shared_event_system
shared_event_system = {
	create = function(self)
		return {
			qualifier = "shared_event_system",
			predicate = function(instance, components)
				return true
			end,
			update = function(instance, dt, components)
				components.game_events:erase_events()
			end
		}
	end
}

return shared_event_system