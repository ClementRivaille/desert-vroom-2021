extends GridMap
class_name ProceduralDesert

var desert_objects: PackedScene = preload("res://prefabs/DesertObjects.tscn")
onready var objects = $Objects

var player_position := Vector2(0,0)

var DEFAULT_TILE := 1
var DISTANCE := 2

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
  
  # Octant borders
  var min_x := (int(player_position.x) - DISTANCE) / cell_octant_size
  var max_x := (int(player_position.x) + DISTANCE) / cell_octant_size
  var min_y := (int(player_position.y) - DISTANCE) / cell_octant_size
  var max_y := (int(player_position.y) + DISTANCE) / cell_octant_size
  
  for cell_coord in existing_cells:
    if (abs(cell_coord.x - player_position.x) > DISTANCE
      || abs(cell_coord.z - player_position.y) > DISTANCE):
      var cell_row := int(cell_coord.x) / cell_octant_size
      var cell_col := int(cell_coord.z) / cell_octant_size
      # avoid deleting a cell out of octant
      if cell_row >= min_x && cell_row <= max_x && cell_col >= min_y && cell_col <= max_y:
        set_cell_item(cell_coord.x, cell_coord.y, cell_coord.z, GridMap.INVALID_CELL_ITEM)
        removed_cells_coord.push_front(Vector2(cell_coord.x, cell_coord.z))
  # remove objects
  for tile_objects in objects.get_children():
    var obj_coord := world_to_map(tile_objects.transform.origin)
    for removed_coord in removed_cells_coord:
      if removed_coord.x == obj_coord.x && removed_coord.y == obj_coord.z:
        objects.remove_child(tile_objects)
  
  # Add new tiles
  for x in range(player_position.x - DISTANCE, player_position.x + DISTANCE + 1):
    for y in range(player_position.y - DISTANCE, player_position.y + DISTANCE + 1):
      var cell := get_cell_item(x, 0, y)
      if cell == GridMap.INVALID_CELL_ITEM:
        set_cell_item(x, 0, y, DEFAULT_TILE)
        # add objects
        var objects_position := map_to_world(x, 0, y)
        var tile_objects: DesertObjects = desert_objects.instance()
        tile_objects.transform.origin = objects_position
        if x == 0:
          tile_objects.road_tile = true
          tile_objects.empty_road = abs(y) < 2
        objects.add_child(tile_objects)

func is_off_road(position: Vector3) -> bool:
  var coordinates := world_to_map(position)
  return coordinates.x != 0
  
