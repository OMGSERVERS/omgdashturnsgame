local match_manager
match_manager = {
	-- Requests
	SIMULATE_STEP = "simulate_step",
	PLAY_EVENTS = "play_events",
	-- Events
	PLAYER_CREATED = "player_created",
	PLAYER_MOVED = "player_moved",
	PLAYER_DEAD = "player_dead",
	PLAYER_DELETED = "player_deleted",
	-- Methods
	simulate_step = function(self, receiver, requests)
		msg.post(receiver, self.SIMULATE_STEP, {
			requests = requests,
		})
	end,
	play_events = function(self, receiver, events)
		msg.post(receiver, self.PLAY_EVENTS, {
			events = events,
		})
	end,
	client_added = function(self, receiver, client_id, nickname, score)
		msg.post(receiver, self.CLIENT_ADDED, {
			client_id = client_id,
			nickname = nickname,
			score = score,
		})
	end,
	player_created = function(self, receiver, client_id, match_player_url, x, y)
		msg.post(receiver, self.PLAYER_CREATED, {
			client_id = client_id,
			match_player_url = match_player_url,
			x = x,
			y = y
		})
	end,
	player_moved = function(self, receiver, client_id, x, y)
		msg.post(receiver, self.PLAYER_MOVED, {
			client_id = client_id,
			x = x,
			y = y
		})
	end,
	player_dead = function(self, receiver, client_id)
		msg.post(receiver, self.PLAYER_DEAD, {
			client_id = client_id,
		})
	end,
	player_deleted = function(self, receiver, client_id)
		msg.post(receiver, self.PLAYER_DELETED, {
			client_id = client_id,
		})
	end,
	client_deleted = function(self, receiver, client_id)
		msg.post(receiver, self.CLIENT_DELETED, {
			client_id = client_id,
		})
	end,
}

return match_manager