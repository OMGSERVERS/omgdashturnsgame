local ops_screen
ops_screen = {
	CHANGE_SCREEN = "change_screen",
	-- Methods
	change_screen = function(self, receiver, state_text)
		msg.post(receiver, ops_screen.CHANGE_SCREEN, {
			state_text = state_text,
		})
	end,
}

return ops_screen