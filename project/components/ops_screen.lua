local ops_screen
ops_screen = {
	-- Methods
	create = function(self)
		local state_text = nil

		return {
			qualifier = "ops_screen",
			-- Methods
			set_state_text = function(instance, new_text)
				print(os.date() .. " [OPS SCREEN] Set state, text=" .. tostring(new_text))
				state_text = new_text
			end,
			get_state_text = function(instance)
				return state_text
			end,
		}
	end
}

return ops_screen