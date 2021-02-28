extends GridMap
class_name ProceduralDesert

var desert_objects: PackedScene = preload("res://prefabs/DesertObjects.tscn")
onready var objects = $Objects

var player_position := Vector2(0,0)

var DEFAULT_TILE := 1

func _ready():
  generate_world()

func update_player_position(position: Vector3):
  var coordinates := world_to_map(position)
  if coordinates.x != player_position.x || coordinates.z != player_position.y:
    player_position = Vector2(coordinates.x, coordinates.z)
    generate_world()
    
func generate_world():
  # Remove far tiles
  var existing_cells := get_used_cells()
  var removed_cells_coord := []
  for cell_coord in existing_cells:
    if abs(cell_coord.x - player_position.x) > 1 || abs(cell_coord.z - player_position.y) > 1:
      set_cell_item(cell_coord.x, cell_coord.y, cell_coord.z, GridMap.INVALID_CELL_ITEM)
      removed_cells_coord.push_front(Vector2(cell_coord.x, cell_coord.z))
  # remove objects
  for tile_objects in objects.get_children():
    var obj_coord := world_to_map(tile_objects.transform.origin)
    for removed_coord in removed_cells_coord:
      if removed_coord.x == obj_coord.x && removed_coord.y == obj_coord.z:
        objects.remove_child(tile_objects)
  
  # Add new tiles
  for x in range(player_position.x -1, player_position.x + 1 + 1):
    for y in range(player_position.y -1, player_position.y + 1 + 1):
      var cell := get_cell_item(x, 0, y)
      if cell == GridMap.INVALID_CELL_ITEM:
        set_cell_item(x, 0, y, DEFAULT_TILE)
        # add objects
        var objects_position := map_to_world(x, 0, y)
        var tile_objects: DesertObjects = desert_objects.instance()
        tile_objects.transform.origin = objects_position
        if x == 0:
          tile_objects.road_tile = true
        objects.add_child(tile_objects)

func is_off_road(position: Vector3) -> bool:
  var coordinates := world_to_map(position)
  return coordinates.x != 0
  
