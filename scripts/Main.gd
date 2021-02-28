extends Spatial
class_name Main

onready var player: Car = $Car
onready var desert_map: ProceduralDesert = $DesertMap
onready var generation_timer: Timer = $GenerationTimer
onready var sky_exit: Area = $SkyExit
onready var environment: AdaptiveEnvironment = $WorldEnvironment

export(Environment) var space_environment: Environment

var space_scene: PackedScene = preload("res://scenes/Space.tscn")
var space_loaded := false

func _ready():
  randomize()

func update_player_position():
  desert_map.update_player_position(player.global_transform.origin)
  sky_exit.global_transform.origin.x = player.global_transform.origin.x
  sky_exit.global_transform.origin.z = player.global_transform.origin.z


func on_exit_sky(_body: PhysicsBody):
  if !space_loaded:
    space_loaded = true
    generation_timer.stop()
    
    player.deactivate_gravity()
    
    environment.transition_to(space_environment)
    yield(environment, "transition_done")
    
    var space: Space = space_scene.instance()
    add_child(space)
    space.global_transform.origin = player.global_transform.origin
    
    space.connect("exit", self, "on_exit_space")
    
func on_exit_space():
  print("WE'RE ON ANOTHER PLANET!")

