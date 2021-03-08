extends Spatial
class_name DesertObjects

export(Array, PackedScene) var common: Array = []
export(Array, PackedScene) var rare: Array = []

var road: PackedScene = preload("res://prefabs/desert/RoadTile.tscn")

export(bool) var road_tile = false
export(bool) var empty_road = false

export(int) var average_nb := 4

var TILE_SIZE = 256;

func _ready():
  if !road_tile:
    distribute_objects()
  else:
    var road_node: RoadTile = road.instance()
    road_node.empty = empty_road
    add_child(road_node)
    
    # Add one random objects why not
    if !empty_road && randf() > 0.5:
      var prefab = common[randi()%common.size()]
      var child: Spatial = prefab.instance()
      var left = -1 if randf() > 0.5 else 1
      child.transform.origin = Vector3(
        left * (road_node.ROAD_WIDTH + 10 + randf() * (TILE_SIZE/2 - road_node.ROAD_WIDTH)),
        0,
      -TILE_SIZE/2 + randf() * TILE_SIZE)
      add_child(child)
  
  
func distribute_objects():
  var nb_items := average_nb + -2 + randi()%4
  var picked_items := []
  
  for i in range(nb_items):
    var picked := randi()%common.size()
    while picked_items.find(picked) != -1:
      picked = randi()%common.size()

    picked_items.push_front(picked)
    var prefab: PackedScene = common[picked]
    place_object(prefab)
        
  # add a rare object
  if randf() < 0.2:
    var rare_prefab = rare[randi()%rare.size()]
    place_object(rare_prefab)

func place_object(prefab: PackedScene):
  var child: Spatial = prefab.instance()
  child.transform.origin = Vector3(-TILE_SIZE/2 + randf() * TILE_SIZE, 0, -TILE_SIZE/2 + randf() * TILE_SIZE)
  add_child(child)
