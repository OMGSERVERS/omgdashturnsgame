local match_player
match_player = {
	SETUP_PLAYER = "setup_player",
	MOVE_PLAYER = "move_player",
	KILL_PLAYER = "kill",
	-- Methods
	setup_player = function(self, recipient, match_manager_url, client_id, nickname)
		msg.post(recipient, match_player.SETUP_PLAYER, {
			match_manager_url = match_manager_url,
			client_id = client_id,
			nickname = nickname,
		})
	end,
	move_player = function(self, recipient, x, y)
		msg.post(recipient, match_player.MOVE_PLAYER, {
			x = x,
			y = y,
		})
	end,
	kill_player = function(self, recipient)
		msg.post(recipient, match_player.KILL_PLAYER, {
		})
	end,
}

return match_player