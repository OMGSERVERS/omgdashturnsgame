local player_wrapper
player_wrapper = {
	INSTANCE_QUALIFIER = "player_wrapper",
	-- Methods
	create = function(self, player_client_id, player_collection_ids)
		assert(player_collection_ids, "plaer collection ids is nil")

		local client_id = player_client_id
		local collection_ids = player_collection_ids

		return {
			qualifier = player_wrapper.INSTANCE_QUALIFIER,
			-- Methods
			get_client_id = function()
				return client_id
			end,
			get_collection_ids = function(instance)
				return collection_ids
			end,
			delete_collection_gos = function(instance)
				print(os.date() .. " [PLAYER_WRAPPER] Delete collection gos, client_id=" .. client_id)
				pprint(collection_ids)
				for _, go_url in pairs(collection_ids) do
					go.delete(go_url)
				end
			end,
			get_player_url = function(instance)
				return collection_ids["/match_player"]
			end,
			get_collision_object_component_url = function(instance)
				local match_player_url = collection_ids["/match_player"]
				return msg.url(nil, match_player_url, "collisionobject")
			end,
			get_player_nickname_component_url = function(instance)
				local match_player_url = collection_ids["/match_player"]
				return msg.url(nil, match_player_url, "nickname")
			end,
			get_player_skin_url = function(instance)
				return collection_ids["/skin"]
			end,
			get_player_skin_sprite_component_url = function(instance)
				local player_skin = collection_ids["/skin"]
				return msg.url(nil, player_skin, "sprite")
			end,
			get_weapon_left_hand_url = function(instance)
				return collection_ids["/weapon_left_hand"]
			end,
			get_weapon_right_hand_url = function(instance)
				return collection_ids["/weapon_right_hand"]
			end,
		}
	end
}

return player_wrapper