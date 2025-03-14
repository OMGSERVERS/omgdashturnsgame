local movement_factory = require("project.utils.movement_factory")
local player_wrapper = require("project.utils.player_wrapper")
local game_events = require("project.messages.game_events")

local level_utils
level_utils = {
	-- Methods
	create_player = function(self, components, client_id, position)
		local wrapped_level = components.level_state:get_wrapped_level()
		if wrapped_level then
			print(os.date() .. " [LEVEL_UTILS] Create player, client_id=" .. client_id .. ", position=" .. position)
			
			local player_factory_component_url = wrapped_level:get_player_factory_component_url()
			local player_collection_ids = collectionfactory.create(player_factory_component_url, position)
			pprint(player_collection_ids)

			local wrapped_player = player_wrapper:create(client_id, player_collection_ids)
			components.level_players:add_wrapped_player(wrapped_player)

			if components.entrypoint_state:is_client_mode() then
				local collission_object_component_url = wrapped_player:get_collision_object_component_url()
				msg.post(collission_object_component_url, "disable")
			end

			local new_game_event = game_events:player_created(client_id)
			components.game_events:add_event(new_game_event)
		end
	end,
	delete_player = function(self, components, client_id)
		local wrapped_player = components.level_players:get_wrapped_player(client_id)
		if wrapped_player then
			print(os.date() .. " [LEVEL_UTILS] Delete player, client_id=" .. client_id)
			wrapped_player:delete_collection_gos()
			components.level_players:delete_player(client_id)

			local new_game_event = game_events:player_deleted(client_id)
			components.game_events:add_event(new_game_event)
		end
	end,
	create_movement = function(self, components, client_id, x, y)
		local wrapped_player = components.level_players:get_wrapped_player(client_id)
		if wrapped_player then
			local player_url = wrapped_player:get_player_url()
			local from_position = go.get_position(player_url)

			local z = y
			local to_position = vmath.vector3(x, y, z)

			local result = physics.raycast(from_position, to_position, { hash("level") })
			if result then
				local hit_position = result.position
				hit_position.z = hit_position.y
				local distance = vmath.length(hit_position - from_position)
				if distance < 16 then
					to_position = from_position
				else
					to_position = hit_position
				end
			end

			local movement = movement_factory:create(client_id, from_position, to_position)
			components.level_movements:add_movement(movement)

			local new_game_event = game_events:movement_created(client_id, x, y)
			components.game_events:add_event(new_game_event)
		end
	end,
}

return level_utils