extends Spatial
class_name Main

onready var player: Car = $Car
onready var desert_map: ProceduralDesert = $DesertMap
onready var generation_timer: Timer = $GenerationTimer
onready var sky_exit: Area = $SkyExit

func _ready():
  randomize()

func update_player_position():
  desert_map.update_player_position(player.global_transform.origin)
  sky_exit.global_transform.origin.x = player.global_transform.origin.x
  sky_exit.global_transform.origin.z = player.global_transform.origin.z


func on_exit_sky(_body: PhysicsBody):
  generation_timer.stop()
  

