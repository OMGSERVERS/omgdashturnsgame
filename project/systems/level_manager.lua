local game_events = require("project.messages.game_events")

local level_manager
level_manager = {
	LEVEL_FACTORY = "/level_factory",
	TILE_W = 16,
	TILE_H = 16,
	-- Methods
	create = function(self)
		local create_level = function(components, level_qualifier)
			local prev_level_ids = components.level_state:get_collection_ids()
			if prev_level_ids then
				for key, level_go_id in pairs(prev_level_ids) do
					go.delete(level_go_id)
				end
			end
			
			local level_factory_url = msg.url(nil, level_manager.LEVEL_FACTORY, level_qualifier)
			local new_level_ids = collectionfactory.create(level_factory_url)
			pprint(new_level_ids)

			local level_tilemap_component_url = msg.url(nil, new_level_ids["/level_tilemap"], "level_tilemap")
			local x, y, w, h = tilemap.get_bounds(level_tilemap_component_url)
			local level_bounds = {
				x = x * level_manager.TILE_W - level_manager.TILE_W,
				y = y * level_manager.TILE_H - level_manager.TILE_H,
				w = w * level_manager.TILE_W,
				h = h * level_manager.TILE_H,
			}
			
			components.level_state:set_level(level_qualifier, new_level_ids, level_bounds)
			
			local new_event = game_events:level_created()
			components.game_events:add_event(new_event)
		end
		
		return {
			qualifier = "level_manager",
			predicate = function(instance, components)
				return true
			end,
			match_screen_created = function(instance, components, event)
				local level_qualifier = components.match_state:get_level_qualifier()
				print(os.date() .. " [LEVEL_MANAGER] Match screen created, creating level, level_qualifier=" .. level_qualifier)
				create_level(components, level_qualifier)
			end,
			state_initialized = function(instance, components, event)
				local level_qualifier = components.match_state:get_level_qualifier()
				print(os.date() .. " [LEVEL_MANAGER] State initialized, creating level, level_qualifier=" .. level_qualifier)
				create_level(components, level_qualifier)
			end,
			update = function(instance, dt, components)
			end
		}
	end
}

return level_manager