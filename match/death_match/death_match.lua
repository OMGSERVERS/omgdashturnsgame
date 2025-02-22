local death_match
death_match = {
	SET_LEVEL = "set_level",
	-- Methods
	set_state = function(self, receiver, level)
		msg.post(receiver, self.SET_LEVEL, {
			level = level,
		})
	end,
}

return death_match