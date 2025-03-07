local server_messages
server_messages = {
	FOREST_LEVEL = "forest_level",
	SET_PROFILE = "set_profile",
	SET_STATE = "set_state",
	PLAY_EVENTS = "play_events",
	-- Methods
	set_profile = function(self, profile)
		return {
			qualifier = server_messages.SET_PROFILE,
			profile = profile,
		}
	end,
	set_state = function(self, settings, state, step)
		return {
			qualifier = server_messages.SET_STATE,
			settings = settings,
			state = state,
			step = step,
		}
	end,
	play_events = function(self, events)
		return {
			qualifier = server_messages.PLAY_EVENTS,
			events = events,
		}
	end,
}

return server_messages