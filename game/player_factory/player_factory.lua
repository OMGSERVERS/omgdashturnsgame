local player_factory
player_factory = {
	-- Requests
	SETUP_FACTORY = "setup_factory",
	CREATE_PLAYER = "create_player",
	DELETE_PLAYER = "delete_player",
	-- Methods
	setup_factory = function(self, receiver, match_manager_url)
		msg.post(receiver, self.SETUP_FACTORY, {
			match_manager_url = match_manager_url,
		})
	end,
	create_player = function(self, receiver, client_id, position, nickname)
		msg.post(receiver, self.CREATE_PLAYER, {
			client_id = client_id,
			position = position,
			nickname = nickname,
		})
	end,
	delete_player = function(self, receiver, client_id)
		msg.post(receiver, self.DELETE_PLAYER, {
			client_id = client_id,
		})
	end,
}

return player_factory