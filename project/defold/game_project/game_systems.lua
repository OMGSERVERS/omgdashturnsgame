local game_entrypoint = require("project.systems.game_entrypoint")
local client_manager = require("project.systems.client_manager")
local screen_manager = require("project.systems.screen_manager")
local auth_screen = require("project.systems.auth_screen")
local lobby_screen = require("project.systems.lobby_screen")
local joining_screen = require("project.systems.joining_screen")
local leaving_screen = require("project.systems.leaving_screen")
local match_screen = require("project.systems.match_screen")
local match_camera = require("project.systems.match_camera")
local match_pointer = require("project.systems.match_pointer")
local match_timer = require("project.systems.match_timer")
local ops_screen = require("project.systems.ops_screen")
local server_manager = require("project.systems.server_manager")
local lobby_runtime = require("project.systems.lobby_runtime")
local match_runtime = require("project.systems.match_runtime")
local match_simulator = require("project.systems.match_simulator")
local death_match = require("project.systems.death_match")
local level_manager = require("project.systems.level_manager")
local level_players = require("project.systems.level_players")
local level_movements = require("project.systems.level_movements")
local events_manager = require("project.systems.events_manager")

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
			death_match:create(),
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