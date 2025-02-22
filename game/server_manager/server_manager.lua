local server_manager
server_manager = {
	RECEIVER = "/server_manager#server_manager",
	-- Requests
	START = "start",
	-- Events
	MATCH_CREATED = "match_created",
	-- Methods
	start = function(self)
		msg.post(self.RECEIVER, self.START, {
		})
	end,
	match_created = function(self, message)
		msg.post(self.RECEIVER, self.MATCH_CREATED, message)
	end,
}

return server_manager