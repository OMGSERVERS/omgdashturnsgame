local ops_screen
ops_screen = {
	SETUP_SCREEN = "setup_screen",
	-- Methods
	setup_screen = function(self, receiver, state_text)
		msg.post(receiver, self.SETUP_SCREEN, {
			state_text = state_text,
		})
	end,
}

return ops_screen