local match_events
match_events = {
	CLIENT_ADDED = "client_added",
	PLAYER_CREATED = "player_created",
	PLAYER_MOVED = "player_moved",
	PLAYER_KILLED = "player_killed",
	PLAYER_DELETED = "player_deleted",
	CLIENT_DELETED = "client_deleted",
	-- Methods
	client_added = function(self, client_id, nickname, score)
		return {
			qualifier = match_events.CLIENT_ADDED,
			client_id = client_id,
			nickname = nickname,
			score = score,
		}
	end,
	player_created = function(self, client_id, x, y)
		return {
			qualifier = match_events.PLAYER_CREATED,
			client_id = client_id,
			x = x,
			y = y,
		}
	end,
	player_moved = function(self, client_id, x, y)
		return {
			qualifier = match_events.PLAYER_MOVED,
			client_id = client_id,
			x = x,
			y = y,
		}
	end,
	player_killed = function(self, client_id, killer_id)
		return {
			qualifier = match_events.PLAYER_KILLED,
			client_id = client_id,
			killer_id = killer_id,
		}
	end,
	player_deleted = function(self, client_id)
		return {
			qualifier = match_events.PLAYER_DELETED,
			client_id = client_id,
		}
	end,
	client_deleted = function(self, client_id)
		return {
			qualifier = match_events.CLIENT_DELETED,
			client_id = client_id,
		}
	end,
}

return match_events