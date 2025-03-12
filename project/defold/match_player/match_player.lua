local match_player
match_player = {
	SETUP_PLAYER = "setup_player",
	-- Methods
	setup_player = function(self, recipient, client_id, disable_collisions)
		msg.post(recipient, self.SETUP_PLAYER, {
			client_id = client_id,
			disable_collisions = disable_collisions,
		})
	end,
}

return match_player