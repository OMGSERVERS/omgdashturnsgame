local profiles_container
profiles_container = {
	wrapped_profiles = {},
	-- Methods
	add_profile = function(self, client_id, wrapped_profile)
		if self.wrapped_profiles[client_id] then
			print(os.date() .. " [PROFILE_CONTAINER] Profile was already added, skip operation, client_id=" .. client_id .. ", nickname=" .. wrapped_profile.profile.data.nickname)
			return false
		else
			self.wrapped_profiles[client_id] = wrapped_profile
			print(os.date() .. " [PROFILE_CONTAINER] Profile was added, client_id=" .. client_id .. ", nickname=" .. wrapped_profile.profile.data.nickname)
			return true
		end
	end,
	get_profile = function(self, client_id)
		return self.wrapped_profiles[client_id]
	end,
	delete_profile = function(self, client_id)
		if self.wrapped_profiles[client_id] then
			self.wrapped_profiles[client_id] = nil
			print(os.date() .. " [PROFILE_CONTAINER] Profile was deleted, client_id=" .. client_id)
			return true
		else
			print(os.date() .. " [PROFILE_CONTAINER] Profile was not found to delete, client_id=" .. client_id)
			return false
		end
	end,
}

return profiles_container