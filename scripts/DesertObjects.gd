extends Spatial
class_name DesertObjects

export(Array, PackedScene) var common: Array = []
export(Array, PackedScene) var rare: Array = []
export(Array, PackedScene) var road: Array = []

export(bool) var road_tile = false

export(int) var average_nb := 4

var TILE_SIZE = 256;

func _ready():
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
  if randf() < 0.3:
    var rare_prefab = rare[randi()%rare.size()]
    place_object(rare_prefab)

func place_object(prefab: PackedScene):
  var child: Spatial = prefab.instance()
  child.transform.origin = Vector3(-TILE_SIZE/2 + randf() * TILE_SIZE, 0, -TILE_SIZE/2 + randf() * TILE_SIZE)
  add_child(child)
