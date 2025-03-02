local death_match
death_match = {
	-- Requests
	SETUP_MATCH = "setup_match",
	-- Methods
	setup_match = function(self, receiver, game_manager_url, settings, match_state, step_index)
		msg.post(receiver, self.SETUP_MATCH, {
			game_manager_url = game_manager_url,
			settings = settings,
			match_state = match_state,
			step_index = step_index,
		})
	end,
}

return death_match