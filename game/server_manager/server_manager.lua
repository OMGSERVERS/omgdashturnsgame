local server_manager
server_manager = {
	RECEIVER = "/server_manager#server_manager",
	-- Requests
	START = "start",
	-- Methods
	start = function(self)
		msg.post(self.RECEIVER, self.START, {
		})
	end,
}

return server_manager