local movement_factory
movement_factory = {
	INSTANCE_QUALIFIER = "movement_instance",
	create = function(self, movement_client_id, movement_from_position, movement_to_position)
		local client_id = movement_client_id
		local from_position = movement_from_position
		local to_position = movement_to_position
		
		return {
			qualifier = movement_factory.INSTANCE_QUALIFIER,
			get_client_id = function(instance)
				return client_id
			end,
			get_from_position = function(instance)
				return from_position
			end,
			get_to_position = function(instance)
				return to_position
			end,
			set_to_position = function(instance, new_to_position)
				pprint(new_to_position)
				to_position = new_to_position
			end,
			get_distance_sqr = function(instance)
				return vmath.length_sqr(to_position - from_position)
			end,
		}
	end
}

return movement_factory