local server_messages
server_messages = {
	SET_PROFILE = "set_profile",
	SET_STATE = "set_state",
	PLAY_EVENTS = "play_events",
	SET_COUNTDOWN = "set_countdown",
	-- Methods
	set_profile = function(self, profile)
		return {
			qualifier = server_messages.SET_PROFILE,
			profile = profile,
		}
	end,
	set_state = function(self, settings, match_state, step_index)
		return {
			qualifier = server_messages.SET_STATE,
			settings = settings,
			match_state = match_state,
			step_index = step_index,
		}
	end,
	play_events = function(self, events)
		return {
			qualifier = server_messages.PLAY_EVENTS,
			events = events,
		}
	end,
	set_countdown = function(self, time_to_spawn)
		return {
			qualifier = server_messages.SET_COUNTDOWN,
			time_to_spawn = time_to_spawn,
		}
	end
}

return server_messages