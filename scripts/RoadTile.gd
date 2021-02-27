extends Spatial
class_name RoadTile

export(Array, PackedScene) var obstacles: Array = []
export(bool) var empty = false

var ROAD_WIDTH := 32
var ROAD_LENGTH = 256
var margin := 5

func _ready():
  if empty:
    return

  var nb_items := 3
  var picked_items := []
  
  for i in range(nb_items):
    var picked := randi()%obstacles.size()
    while picked_items.find(picked) != -1:
      picked = randi()%obstacles.size()

    picked_items.push_front(picked)
    var prefab: PackedScene = obstacles[picked]
    place_object(prefab)

func place_object(prefab: PackedScene):
  var child: Spatial = prefab.instance()
  var left = -1 if randf() > 0.5 else 1
  child.transform.origin = Vector3(randf() * (ROAD_WIDTH - margin) * left,
    0.05,
    -ROAD_LENGTH/2 + randf() * ROAD_LENGTH)
  add_child(child)
