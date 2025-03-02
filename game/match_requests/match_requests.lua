local match_requests
match_requests = {
	-- Events
	ADD_CLIENT = "add_client",
	SPAWN_PLAYER = "client_added",
	MOVE_PLAYER = "move_player",
	DELETE_PLAYER = "delete_player",
	DELETE_CLIENT = "delete_client",
	-- Methods
	add_client = function(self, client_id, nickname, score)
		return {
			qualifier = match_requests.ADD_CLIENT,
			client_id = client_id,
			nickname = nickname,
			score = score,
		}
	end,
	spawn_player = function(self, client_id)
		return {
			qualifier = match_requests.SPAWN_PLAYER,
			client_id = client_id,
		}
	end,
	move_player = function(self, client_id, x, y)
		return {
			qualifier = match_requests.MOVE_PLAYER,
			client_id = client_id,
			x = x,
			y = y,
		}
	end,
	delete_player = function(self, client_id)
		return {
			qualifier = match_requests.DELETE_PLAYER,
			client_id = client_id,
		}
	end,
	delete_client = function(self, client_id)
		return {
			qualifier = match_requests.DELETE_CLIENT,
			client_id = client_id,
		}
	end,
}

return match_requests