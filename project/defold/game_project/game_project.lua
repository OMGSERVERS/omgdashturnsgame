local game_project
game_project = {
	RESET_PRESSED = "reset_pressed",
	JOIN_PRESSED = "join_pressed",
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
}

return game_project