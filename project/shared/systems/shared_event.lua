local shared_event
shared_event = {
	create = function(self)
		return {
			qualifier = "shared_event",
			predicate = function(instance, components)
				return true
			end,
			update = function(instance, dt, components)
				components.shared.events:erase_events()
			end
		}
	end
}

return shared_event