local player_manager
player_manager = {
	create = function(self)

		local set_player_flip = function (components, client_id, flip)
			local player_collection_ids = components.level_state:get_player_collection_ids(client_id)
			if player_collection_ids then
				local player_skin_url = player_collection_ids["/skin"]
				local weapon_left_hand_url = player_collection_ids["/weapon_left_hand"]
				local weapon_right_hand_url = player_collection_ids["/weapon_right_hand"]
				sprite.set_hflip(player_skin_url, flip)
				if flip then
					msg.post(weapon_left_hand_url, "enable")
					msg.post(weapon_right_hand_url, "disable")
				else
					msg.post(weapon_left_hand_url, "disable")
					msg.post(weapon_right_hand_url, "enable")
				end
			end
		end
		
		return {
			qualifier = "player_manager",
			predicate = function(instance, components)
				return true
			end,
			player_created = function(instance, components, event)
				local client_id = event.client_id
				print(os.date() .. " [PLAYER_MANAGER] Player created, client_id=" .. tostring(client_id))

				local nickname = components.match_state:get_nickname(client_id)
				local player_nickname_component_url = components.level_state:get_player_nickname_component_url(client_id)
				label.set_text(player_nickname_component_url, nickname)

				set_player_flip(components, client_id, false)
			end,
			update = function(instance, dt, components)
				local movements_to_delete = {}
				local movements = components.level_state:get_movements()
				if movements then
					for client_id, movement in pairs(movements) do
						local get_player_url = components.level_state:get_player_url(client_id)

						local current_possition = go.get_position(get_player_url)
						local from_position = movement.from_position
						local to_position = movement.to_position

						local total_distance_sqr = vmath.length_sqr(to_position - from_position)
						local current_distance_sqr = vmath.length_sqr(current_possition - from_position)

						if current_distance_sqr >= total_distance_sqr then
							movements_to_delete[#movements_to_delete + 1] = client_id
						end
					end
				end

				for i = 1, #movements_to_delete do
					local client_id = movements_to_delete[i]
					components.level_state:delete_movement(client_id)
				end
			end
		}
	end
}

return player_manager