local game_manager
game_manager = {
	-- Events
	MATCH_CREATED = "match_created",
	MATCH_SIMULATED = "match_simulated",
	-- Methods
	match_created = function(self, receiver, match_qualifier, match_manager_url, bounds)
		msg.post(receiver, self.MATCH_CREATED, {
			match_qualifier = match_qualifier,  
			match_manager_url = match_manager_url,
			bounds = bounds,
		})
	end,
	match_simulated = function(self, receiver, match_state, step_events)
		msg.post(receiver, self.MATCH_SIMULATED, {
			match_state = match_state,
			step_events = step_events,
		})
	end,
}

return game_manager