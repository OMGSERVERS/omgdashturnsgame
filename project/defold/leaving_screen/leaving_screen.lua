local leaving_screen
leaving_screen = {
	CHANGE_SCREEN = "change_screen",
	-- Methods
	change_screen = function(self, receiver, state_text)
		msg.post(receiver, leaving_screen.CHANGE_SCREEN, {
			state_text = state_text,
		})
	end,
}

return leaving_screen