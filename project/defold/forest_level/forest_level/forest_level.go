components {
  id: "level_tilemap"
  component: "/game/forest_level/forest_tilemap.tilemap"
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "collision_shape: \"/project/defold/forest_level/forest_level/forest_tilemap.tilemap\"\n"
  "type: COLLISION_OBJECT_TYPE_STATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"\"\n"
  "mask: \"players\"\n"
  ""
}
