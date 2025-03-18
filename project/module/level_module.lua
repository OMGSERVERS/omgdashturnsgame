local movement_factory = require("project.module.movement_factory")
local player_wrapper = require("project.module.player_wrapper")
local level_wrapper = require("project.module.level_wrapper")
local game_events = require("project.message.game_events")

local level_module
level_module = {
	LEVEL_FACTORY = "/level_factory",
	TILE_W = 16,
	TILE_H = 16,
	-- Methods
	get_z = function(self, y)
		return 512 - y * 0.1
	end,
	delete_level = function(self, components)
		local wrapped_level = components.shared.level:get_wrapped_level()
		if wrapped_level then
			wrapped_level:delete_collection_gos()

			local wrapped_players = components.shared.players:get_wrapped_players()
			if wrapped_players then
				for client_id, wrapped_player in pairs(wrapped_players) do
					wrapped_player:delete_collection_gos()
				end
			end

			local new_event = game_events:level_deleted()
			components.shared.events:add_event(new_event)
		end
	end,
	create_level = function(self, components, level_qualifier)
		level_module:delete_level(components)

		components.shared.level:reset_component()
		components.shared.players:reset_component()
		components.shared.movements:reset_component()

		local level_factory_url = msg.url(nil, level_module.LEVEL_FACTORY, level_qualifier)
		local new_level_ids = collectionfactory.create(level_factory_url)
		pprint(new_level_ids)

		local wrapped_level = level_wrapper:create(new_level_ids)

		local level_background_tilemap_component_url = wrapped_level:get_level_background_tilemap_component_url()
		local x, y, w, h = tilemap.get_bounds(level_background_tilemap_component_url)
		local level_bounds = {
			x = x * level_module.TILE_W - level_module.TILE_W,
			y = y * level_module.TILE_H - level_module.TILE_H,
			w = w * level_module.TILE_W,
			h = h * level_module.TILE_H,
		}

		local spawn_points = {}
		local spawn_point_index = 1
		while true do
			local collection_key = "/spawn_point_" .. spawn_point_index
			local spawn_point_url = new_level_ids[collection_key]
			if spawn_point_url then
				local spawn_position = go.get_position(spawn_point_url)
				spawn_position.z = level_module:get_z(spawn_position.y)
				spawn_points[#spawn_points + 1] = spawn_position

				msg.post(spawn_point_url, "disable")
				spawn_point_index = spawn_point_index + 1
			else
				break
			end
		end

		components.shared.level:setup_level(level_qualifier, wrapped_level, level_bounds, spawn_points)

		local new_event = game_events:level_created()
		components.shared.events:add_event(new_event)
	end,
	create_player = function(self, components, client_id, x, y)
		local wrapped_level = components.shared.level:get_wrapped_level()
		if wrapped_level then
			local z = level_module:get_z(y)
			local position = vmath.vector3(x, y, z)
			print(os.date() .. " [LEVEL_UTILS] Create player, client_id=" .. client_id .. ", position=" .. position)
			
			local player_factory_component_url = wrapped_level:get_player_factory_component_url()
			local player_collection_ids = collectionfactory.create(player_factory_component_url, position)
			pprint(player_collection_ids)

			local wrapped_player = player_wrapper:create(client_id, player_collection_ids)
			components.shared.players:add_wrapped_player(wrapped_player)

			if components.shared.bootstrap:is_client_mode() then
				local collission_object_component_url = wrapped_player:get_collision_object_component_url()
				msg.post(collission_object_component_url, "disable")
			end

			local new_game_event = game_events:player_created(client_id)
			components.shared.events:add_event(new_game_event)
		end
	end,
	delete_player = function(self, components, client_id)
		local wrapped_player = components.shared.players:get_wrapped_player(client_id)
		if wrapped_player then
			print(os.date() .. " [LEVEL_UTILS] Delete player, client_id=" .. client_id)
			wrapped_player:delete_collection_gos()
			components.shared.players:delete_player(client_id)

			local new_game_event = game_events:player_deleted(client_id)
			components.shared.events:add_event(new_game_event)
		end
	end,
	create_movement = function(self, components, client_id, x, y)
		local wrapped_player = components.shared.players:get_wrapped_player(client_id)
		if wrapped_player then
			local player_url = wrapped_player:get_player_url()
			local from_position = go.get_position(player_url)

			local z = level_module:get_z(y)
			local to_position = vmath.vector3(x, y, z)

			local result = physics.raycast(from_position, to_position, { hash("level"), hash("obstacles") })
			if result then
				local hit_position = result.position
				hit_position.z = level_module:get_z(hit_position.y)
				local distance = vmath.length(hit_position - from_position)
				if distance < 16 then
					to_position = from_position
				else
					to_position = hit_position
				end
			end

			local movement = movement_factory:create(client_id, from_position, to_position)
			components.shared.movements:add_movement(movement)

			local new_game_event = game_events:movement_created(client_id, x, y)
			components.shared.events:add_event(new_game_event)
		end
	end,
}

return level_module