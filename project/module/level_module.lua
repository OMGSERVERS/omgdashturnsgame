local movement_factory = require("project.module.movement_factory")
local player_wrapper = require("project.module.player_wrapper")
local level_wrapper = require("project.module.level_wrapper")
local game_events = require("project.message.game_events")

local level_utils
level_utils = {
	LEVEL_FACTORY = "/level_factory",
	TILE_W = 16,
	TILE_H = 16,
	-- Methods
	delete_level = function(self, components)
		local wrapped_level = components.level_state:get_wrapped_level()
		if wrapped_level then
			wrapped_level:delete_collection_gos()

			local wrapped_players = components.level_players:get_wrapped_players()
			if wrapped_players then
				for client_id, wrapped_player in pairs(wrapped_players) do
					wrapped_player:delete_collection_gos()
				end
			end

			local new_event = game_events:level_deleted()
			components.game_events:add_event(new_event)
		end
	end,
	create_level = function(self, components, level_qualifier)
		level_utils:delete_level(components)

		components.level_state:reset_component()
		components.level_players:reset_component()
		components.level_movements:reset_component()
		components.level_kills:reset_component()

		local level_factory_url = msg.url(nil, level_utils.LEVEL_FACTORY, level_qualifier)
		local new_level_ids = collectionfactory.create(level_factory_url)
		pprint(new_level_ids)

		local wrapped_level = level_wrapper:create(new_level_ids)

		local level_tilemap_component_url = wrapped_level:get_level_tilemap_component_url()
		local x, y, w, h = tilemap.get_bounds(level_tilemap_component_url)
		local level_bounds = {
			x = x * level_utils.TILE_W - level_utils.TILE_W,
			y = y * level_utils.TILE_H - level_utils.TILE_H,
			w = w * level_utils.TILE_W,
			h = h * level_utils.TILE_H,
		}

		local spawn_points = {}
		local spawn_point_index = 1
		while true do
			local collection_key = "/spawn_point" .. spawn_point_index
			local spawn_point_url = new_level_ids[collection_key]
			if spawn_point_url then
				local spawn_position = go.get_position(spawn_point_url)
				spawn_position.z = spawn_position.y
				spawn_points[#spawn_points + 1] = spawn_position

				msg.post(spawn_point_url, "disable")
				spawn_point_index = spawn_point_index + 1
			else
				break
			end
		end

		components.level_state:setup_level(level_qualifier, wrapped_level, level_bounds, spawn_points)

		local new_event = game_events:level_created()
		components.game_events:add_event(new_event)
	end,
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