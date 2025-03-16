local shared_events
shared_events = {
	create = function(self)
		local prev_events = {}
		local new_events = {}
		return {
			qualifier = "shared_events",
			-- Methods
			add_event = function(instance, event)
				new_events[#new_events + 1] = event
			end,
			get_events = function(instance)
				return prev_events
			end,
			erase_events = function(instance)
				prev_events = new_events
				new_events = {}
			end,
		}
	end
}

return shared_events