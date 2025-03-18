local game_project
game_project = {
	RESET_PRESSED = "reset_pressed",
	JOIN_PRESSED = "join_pressed",
	LEAVE_PRESSED = "leave_pressed",
	PLAYER_POINTED = "player_pointed",
	SETUP_OBJECT = "setup_object",
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
	setup_object = function(self, receiver)
		msg.post(receiver, game_project.SETUP_OBJECT, {
		})
	end
}

return game_project