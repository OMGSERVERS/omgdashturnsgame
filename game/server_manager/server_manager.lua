local server_manager
server_manager = {
	RECEIVER = "server_manager#server_manager",
	START = "start",
	-- Methods
	start = function(self, receiver)
		msg.post(server_manager.RECEIVER, server_manager.START, {
		})
	end,
}

return server_manager