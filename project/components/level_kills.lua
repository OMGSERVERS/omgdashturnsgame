local level_kills
level_kills = {
	-- Methods
	create = function(self)
		local kills = {}

		return {
			qualifier = "level_kills",
			-- Methods
			reset_component = function(instance)
				kills = {}
			end,
			add_kill = function(instance, killer_id, client_id)
				kills[killer_id] = {
					client_id = client_id
				}
				print(os.date() .. " [LEVEL_STATE] Kill was added, client_id=" .. tostring(client_id) .. ", killer_id=" .. killer_id)
			end,
			get_kill = function(instance, killer_id)
				return kills[killer_id]
			end,
			delete_kill = function(instance, killer_id)
				kills[killer_id] = nil
			end,
		}
	end
}

return level_kills