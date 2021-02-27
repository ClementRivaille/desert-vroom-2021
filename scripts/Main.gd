extends Spatial
class_name Main

onready var player: Car = $Car
onready var desert_map: ProceduralDesert = $DesertMap

func _ready():
  randomize()

func update_player_position():
  desert_map.update_player_position(player.global_transform.origin)
