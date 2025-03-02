local match_screen
match_screen = {
	-- Requests
	SETUP_SCREEN = "setup_screen",
	SET_COUNTDOWN = "set_countdown",
	POINTED = "pointed",
	-- Events
	MATCH_CREATED = "match_created",
	CLIENT_ADDED = "client_added",
	PLAYER_CREATED = "player_created",
	PLAYER_KILLED = "player_killed",
	CLIENT_DELETED = "client_deleted",
	-- Methods
	setup_screen = function(self, receiver, game_manager_url, settings, match_state, step_index)
		msg.post(receiver, self.SETUP_SCREEN, {
			game_manager_url = game_manager_url,
			settings = settings,
			match_state = match_state,
			step_index = step_index,
		})
	end,
	set_countdown = function(self, receiver, time_to_spawn)
		msg.post(receiver, match_screen.SET_COUNTDOWN, {
			time_to_spawn = time_to_spawn,
		})
	end,
	pointed = function(self, receiver, x, y)
		msg.post(receiver, self.POINTED, {
			x = x,
			y = y,
		})
	end,
	client_added = function(self, receiver, client_id, nickname, score)
		msg.post(receiver, self.CLIENT_ADDED, {
			client_id = client_id,
			nickname = nickname,
			score = score,
		})
	end,
	player_created = function(self, receiver, client_id, x, y)
		msg.post(receiver, self.PLAYER_CREATED, {
			client_id = client_id,
			x = x,
			y = y,
		})
	end,
	player_killed = function(self, receiver, client_id, killer_id)
		msg.post(receiver, self.PLAYER_KILLED, {
			client_id = client_id,
			killer_id = killer_id,
		})
	end,
	client_deleted = function(self, receiver, client_id)
		msg.post(receiver, self.CLIENT_DELETED, {
			client_id = client_id,
		})
	end,
}

return match_screen