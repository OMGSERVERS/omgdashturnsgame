local player_manager
player_manager = {
	create = function(self)
		return {
			qualifier = "player_manager",
			predicate = function(instance, components)
				return true
			end,
			update = function(instance, dt, components)

				local movements_to_delete = {}
				local movements = components.level_state:get_movements()
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

				for i = 1, #movements_to_delete do
					local client_id = movements_to_delete[i]
					components.level_state:delete_movement(client_id)
				end
			end
		}
	end
}

return player_manager