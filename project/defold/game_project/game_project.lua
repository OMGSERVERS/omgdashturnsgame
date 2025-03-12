local game_project
game_project = {
	RESET_PRESSED = "reset_pressed",
	JOIN_PRESSED = "join_pressed",
	LEAVE_PRESSED = "leave_pressed",
	PLAYER_POINTED = "player_pointed",
	COLLISION_SOLVED = "collision_solved",
	-- Methods
	reset_pressed = function(self, receiver)
		msg.post(receiver, game_project.RESET_PRESSED, {
		})
	end,
	join_pressed = function(self, receiver, nickname)
		msg.post(receiver, game_project.JOIN_PRESSED, {
			nickname = nickname,
		})
	end,
	leave_pressed = function(self, receiver)
		msg.post(receiver, game_project.LEAVE_PRESSED, {
		})
	end,
	player_pointed = function(self, receiver, x, y)
		msg.post(receiver, game_project.PLAYER_POINTED, {
			x = x,
			y = y,
		})
	end,
	collision_solved = function(self, receiver, client_id, correction)
		msg.post(receiver, game_project.COLLISION_SOLVED, {
			client_id = client_id,
			correction = correction,
		})
	end
}

return game_project