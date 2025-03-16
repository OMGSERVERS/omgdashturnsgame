local joining_screen
joining_screen = {
	-- Methods
	create = function(self)
		local state_text = nil
		
		return {
			qualifier = "joining_screen",
			-- Methods
			set_state_text = function(instance, new_text)
				print(os.date() .. " [JOINING SCREEN] Set state, text=" .. tostring(new_text))
				state_text = new_text
			end,
			get_state_text = function(instance)
				return state_text
			end,
		}
	end
}

return joining_screen