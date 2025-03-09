local leaving_screen
leaving_screen = {
	-- Methods
	create = function(self)
		local state_text = nil
		
		return {
			qualifier = "leaving_screen",
			-- Methods
			set_state_text = function(instance, new_text)
				print(os.date() .. " [LEAVING_SCREEN] Set state, text=" .. tostring(new_text))
				state_text = new_text
			end,
			get_state_text = function(instance)
				return state_text
			end,
		}
	end
}

return leaving_screen