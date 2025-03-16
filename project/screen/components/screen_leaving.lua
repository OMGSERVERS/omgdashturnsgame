local screen_leaving
screen_leaving = {
	-- Methods
	create = function(self)
		local state_text = nil
		
		return {
			qualifier = "screen_leaving",
			-- Methods
			set_state_text = function(instance, new_text)
				print(os.date() .. " [SCREEN_LEAVING] Set state, text=" .. tostring(new_text))
				state_text = new_text
			end,
			get_state_text = function(instance)
				return state_text
			end,
		}
	end
}

return screen_leaving