local match_camera
match_camera = {
	-- Requests
	SETUP_CAMERA = "setup_camera",
	MOVE_CAMERA = "move_camera",
	-- Methods
	setup_camera = function(self, receiver, bounds)
		msg.post(receiver, self.SETUP_CAMERA, {
			bounds = bounds
		})
	end,
	move_camera = function(self, receiver, x, y)
		msg.post(receiver, self.MOVE_CAMERA, {
			x = x,
			y = y,
		})
	end,
}

return match_camera