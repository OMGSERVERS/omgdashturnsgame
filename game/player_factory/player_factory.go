components {
  id: "player_factory"
  component: "/game/player_factory/player_factory.script"
}
embedded_components {
  id: "match_player_factory"
  type: "collectionfactory"
  data: "prototype: \"/game/match_player/match_player.collection\"\n"
  ""
}
