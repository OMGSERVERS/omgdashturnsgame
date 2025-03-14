local game_events = require("project.components.game_events")
local entrypoint_state = require("project.components.entrypoint_state")
local client_state = require("project.components.client_state")
local screen_state = require("project.components.screen_state")
local auth_screen = require("project.components.auth_screen")
local lobby_screen = require("project.components.lobby_screen")
local joining_screen = require("project.components.joining_screen")
local leaving_screen = require("project.components.leaving_screen")
local match_screen = require("project.components.match_screen")
local ops_screen = require("project.components.ops_screen")
local server_state = require("project.components.server_state")
local lobby_runtime = require("project.components.lobby_runtime")
local match_runtime = require("project.components.match_runtime")
local match_simulator = require("project.components.match_simulator")
local match_state = require("project.components.match_state")
local level_state = require("project.components.level_state")
local level_players = require("project.components.level_players")
local level_movements = require("project.components.level_movements")
local level_kills = require("project.components.level_kills")
local death_match = require("project.components.death_match")

local game_components
game_components = {
	create = function(self)
		local components = {
			game_events = game_events:create(),
			entrypoint_state = entrypoint_state:create(),
			client_state = client_state:create(),
			screen_state = screen_state:create(),
			auth_screen = auth_screen:create(),
			lobby_screen = lobby_screen:create(),
			joining_screen = joining_screen:create(),
			leaving_screen = leaving_screen:create(),
			match_screen = match_screen:create(),
			ops_screen = ops_screen:create(),
			server_state = server_state:create(),
			lobby_runtime = lobby_runtime:create(),
			match_runtime = match_runtime:create(),
			match_simulator = match_simulator:create(),
			match_state = match_state:create(),
			level_state = level_state:create(),
			level_players = level_players:create(),
			level_movements = level_movements:create(),
			level_kills = level_kills:create(),
			death_match = death_match:create(),
		}

		local total = 0
		for _ in pairs(components) do
			total = total + 1
		end

		print("Game components, total=" .. total)
		for key, _ in pairs(components) do
			local component = components[key]
			print(" - " .. component.qualifier)
		end
		
		return components
	end
}

return game_components