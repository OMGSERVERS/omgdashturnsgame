local client_kills
client_kills = {
	-- Methods
	create = function(self)
		local kills = {}

		return {
			qualifier = "client_kills",
			-- Methods
			reset_component = function(instance)
				kills = {}
			end,
			add_kill = function(instance, killer_id, client_id)
				print(os.date() .. " [CLIENT_KILLS] Add kill, client_id=" .. tostring(client_id) .. ", killer_id=" .. tostring(killer_id))
				kills[killer_id] = {
					client_id = client_id
				}
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

return client_kills