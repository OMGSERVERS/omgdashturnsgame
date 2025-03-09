local screen_state
screen_state = {
	AUTH_SCREEN = "auth_screen",
	LOBBY_SCREEN = "lobby_screen",
	JOINING_SCREEN = "joining_screen",
	MATCH_SCREEN = "match_screen",
	LEAVING_SCREEN = "leaving_screen",
	OPS_SCREEN = "ops_screen",
	-- Methods
	create = function(self)
		local screen_qualifier = nil
		local collection_ids = nil

		return {
			qualifier = "screen_state",
			-- Methods
			get_collection_ids = function(instance)
				return collection_ids
			end,
			set_auth_screen = function(instance, screen_ids)
				screen_qualifier = screen_state.AUTH_SCREEN
				collection_ids = screen_ids
			end,
			is_auth_screen = function(instance)
				return screen_qualifier == screen_state.AUTH_SCREEN
			end,
			get_auth_screen_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				return collection_ids["/auth_screen"]
			end,
			set_lobby_screen = function(instance, screen_ids)
				screen_qualifier = screen_state.LOBBY_SCREEN
				collection_ids = screen_ids
			end,
			is_lobby_screen = function(instance)
				return screen_qualifier == screen_state.LOBBY_SCREEN
			end,
			get_lobby_screen_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				return collection_ids["/lobby_screen"]
			end,
			set_joining_screen = function(instance, screen_ids)
				screen_qualifier = screen_state.JOINING_SCREEN
				collection_ids = screen_ids
			end,
			is_joining_screen = function(instance)
				return screen_qualifier == screen_state.JOINING_SCREEN
			end,
			get_joining_screen_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				return collection_ids["/joining_screen"]
			end,
			set_match_screen = function(instance, screen_ids)
				screen_qualifier = screen_state.MATCH_SCREEN
				collection_ids = screen_ids
			end,
			is_match_screen = function(instance)
				return screen_qualifier == screen_state.MATCH_SCREEN
			end,
			get_level_factory_url = function(instance, level_qualifier)
				assert(collection_ids, "screen's collection ids is not set")
				local level_factory = collection_ids["/level_factory"]
				local factory_url = msg.url(nil, level_factory, level_qualifier)
				return factory_url
			end,
			get_match_camera_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				return collection_ids["/match_camera"]
			end,
			get_match_camera_component_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				local match_camera = collection_ids["/match_camera"]
				local match_camera_component_url = msg.url(nil, match_camera, "camera")
				return match_camera_component_url
			end,
			get_match_pointer_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				return collection_ids["/match_pointer"]
			end,
			set_leaving_screen = function(instance, screen_ids)
				screen_qualifier = screen_state.LEAVING_SCREEN
				collection_ids = screen_ids
			end,
			is_leaving_screen = function(instance)
				return screen_qualifier == screen_state.LEAVING_SCREEN
			end,
			get_leaving_screen_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				return collection_ids["/leaving_screen"]
			end,
			set_ops_screen = function(instance, screen_ids)
				screen_qualifier = screen_state.OPS_SCREEN
				collection_ids = screen_ids
			end,
			is_ops_screen = function(instance)
				return screen_qualifier == screen_state.OPS_SCREEN
			end,
			get_ops_screen_url = function(instance)
				assert(collection_ids, "screen's collection ids is not set")
				return collection_ids["/ops_screen"]
			end,
		}
	end
}

return screen_state