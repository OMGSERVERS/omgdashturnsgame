local movement_factory = require("project.module.movement_factory")

local level_movements
level_movements = {
	-- Methods
	create = function(self)
		local movements = {}
		
		return {
			qualifier = "level_movements",
			-- Methods
			reset_component = function(instance)
				movements = {}
			end,
			add_movement = function(instance, movement)
				assert(movement.qualifier == movement_factory.INSTANCE_QUALIFIER, "movement.qualifier is incorrect")
				local client_id = movement:get_client_id()
				movements[client_id] = movement
				print(os.date() .. " [LEVEL_MOVEMENTS] Movement was added, client_id=" .. tostring(client_id))
			end,
			get_movement = function(instance, client_id)
				return movements[client_id]
			end,
			delete_movement = function(instance, client_id)
				movements[client_id] = nil
			end,
			delete_by_client_ids = function(instance, client_ids)
				for _, client_id in ipairs(client_ids) do
					movements[client_id] = nil
				end
			end,
			get_movements = function(instance)
				return movements
			end,
		}
	end
}

return level_movements