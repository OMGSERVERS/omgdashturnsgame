local level_wrapper
level_wrapper = {
	INSTANCE_QUALIFIER = "level_wrapper",
	-- Methods
	create = function(self, level_collection_ids)
		assert(level_collection_ids, "level collection ids is nil")
		
		local collection_ids = level_collection_ids

		return {
			qualifier = level_wrapper.INSTANCE_QUALIFIER,
			-- Methods
			get_collection_ids = function(instance)
				return collection_ids
			end,
			delete_collection_gos = function(instance)
				print(os.date() .. " [LEVEL_WRAPPER] Delete collection gos")
				pprint(collection_ids)
				for _, go_url in pairs(collection_ids) do
					go.delete(go_url)
				end
			end,
			get_camera_point_url = function(instance)
				return collection_ids["/camera_point"]
			end,
			get_level_tilemap_component_url = function(instance)
				local level_tilemap_url = collection_ids["/level_tilemap"]
				return msg.url(nil, level_tilemap_url, "level_tilemap")
			end,
			get_player_factory_component_url = function(instance)
				local player_factory_url = collection_ids["/player_factory"]
				return msg.url(nil, player_factory_url, "player_factory")
			end,
		}
	end
}

return level_wrapper