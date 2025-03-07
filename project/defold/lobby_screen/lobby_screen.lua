local lobby_screen
lobby_screen = {
	SETUP_SCREEN = "setup_screen",
	-- Methods
	setup_screen = function(self, recipient, profile)
		msg.post(recipient, self.SETUP_SCREEN, {
			profile = profile,
		})
	end,
}

return lobby_screen