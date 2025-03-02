local match_pointer
match_pointer = {
	RECEIVER = "match_pointer#match_pointer",
	-- Requests
	ENABLE_POINTER = "enable_pointer",
	DISABLE_POINTER = "disable_pointer",
	SWITCH_POINTER = "switch_pointer",
	-- Methods
	enable_pointer = function(self, x, y)
		msg.post(self.RECEIVER, match_pointer.ENABLE_POINTER, {
			x = x,
			y = y,
		})
	end,
	disable_pointer = function(self)
		msg.post(self.RECEIVER, match_pointer.DISABLE_POINTER, {
		})
	end,
	switch_pointer = function(self, x, y)
		msg.post(self.RECEIVER, match_pointer.SWITCH_POINTER, {
			x = x,
			y = y,
		})
	end,
}

return match_pointer