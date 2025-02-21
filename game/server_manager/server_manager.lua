local server_manager
server_manager = {
	RECEIVER = "/server_manager#server_manager",
	-- Events
	SERVER_STARTED = "server_started",
	-- Methods
	server_started = function(self)
		msg.post(self.RECEIVER, self.SERVER_STARTED, {
		})
	end,
}

return server_manager