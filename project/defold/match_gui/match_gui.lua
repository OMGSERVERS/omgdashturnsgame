local match_gui
match_gui = {
	RESET_PROGRESS_BAR = "reset_progress_bar",
	-- Methods
	reset_progress_bar = function(self, receiver, timer_value)
		msg.post(receiver, match_gui.RESET_PROGRESS_BAR, {
			timer_value = timer_value,
		})
	end,
}

return match_gui