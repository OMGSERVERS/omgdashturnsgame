local physics_listener
physics_listener = {
	-- Methods
	create = function(self)
		return function(self, event, data)
			if event == hash("contact_point_event") then
				pprint(data)
			end
		end
	end,
}

return physics_listener