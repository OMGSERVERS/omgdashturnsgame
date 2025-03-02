local auth_screen
auth_screen = {
	CHANGE_SCREEN = "change_screen",
	-- Methods
	change_screen = function(self, receiver, state_text)
		msg.post(receiver, auth_screen.CHANGE_SCREEN, {
			state_text = state_text,
		})
	end,
}

return auth_screen