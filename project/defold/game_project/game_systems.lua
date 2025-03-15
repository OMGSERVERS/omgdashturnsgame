local game_entrypoint = require("project.core.systems.game_entrypoint")
local client_manager = require("project.client.systems.client_manager")
local screen_manager = require("project.client.systems.screen_manager")
local auth_screen = require("project.screens.systems.auth_screen")
local lobby_screen = require("project.screens.systems.lobby_screen")
local joining_screen = require("project.screens.systems.joining_screen")
local leaving_screen = require("project.screens.systems.leaving_screen")
local match_screen = require("project.screens.systems.match_screen")
local ops_screen = require("project.screens.systems.ops_screen")
local match_camera = require("project.match.systems.match_camera")
local match_pointer = require("project.match.systems.match_pointer")
local match_timer = require("project.match.systems.match_timer")
local server_manager = require("project.server.systems.server_manager")
local lobby_runtime = require("project.server.systems.lobby_runtime")
local match_runtime = require("project.server.systems.match_runtime")
local match_simulator = require("project.systems.match_simulator")
local level_deathmatch = require("project.level.systems.level_deathmatch")
local level_manager = require("project.level.systems.level_manager")
local level_players = require("project.level.systems.level_players")
local level_movements = require("project.level.systems.level_movements")
local events_manager = require("project.core.systems.events_manager")

local game_systems
game_systems = {
	create = function(self, components)
		local systems = {
			-- Client
			client_manager:create(),
			screen_manager:create(),
			auth_screen:create(),
			lobby_screen:create(),
			joining_screen:create(),
			leaving_screen:create(),
			match_screen:create(),
			match_camera:create(),
			match_pointer:create(),
			match_timer:create(),
			ops_screen:create(),
			-- Server
			server_manager:create(),
			lobby_runtime:create(),
			match_runtime:create(),
			match_simulator:create(),
			-- Shared
			game_entrypoint:create(),
			level_manager:create(),
			level_players:create(),
			level_movements:create(),
			level_deathmatch:create(),
			events_manager:create(),
		}

		print("Game systems, total=" .. #systems)
		for i = 1,#systems do
			local system = systems[i]
			print(" - " .. system.qualifier)
		end
		
		return {
			id = "game_systems",
			-- Methods
			update = function(instance, dt)
				for system_index = 1, #systems do
					local system = systems[system_index]
					if system:predicate(components) then
						local events = components.game_events:get_events()
						for event_index = 1, #events do
							local event = events[event_index]
							local qualifier = event.id
							if system[qualifier] then
								system[qualifier](system, components, event)
							end
						end
						system:update(dt, components)
					end
				end
			end,
		}
	end
}

return game_systems