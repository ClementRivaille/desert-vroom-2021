extends Spatial
class_name Main

onready var player: Car = $Car
onready var desert_map: ProceduralDesert = $DesertMap
onready var generation_timer: Timer = $GenerationTimer
onready var sky_exit: Area = $SkyExit
onready var environment: AdaptiveEnvironment = $WorldEnvironment
onready var ui: UI = $UI
onready var events_timer: Timer = $EventsTimer

export(Environment) var space_environment: Environment
export(Environment) var glitch_environment: Environment
export(Environment) var end_environment: Environment

var space_scene: PackedScene = preload("res://scenes/Space.tscn")
var space_loaded := false

var glitch_scene: PackedScene = preload("res://scenes/Glitch.tscn")
var glitch_loaded := false

var end_scene: PackedScene = preload("res://scenes/End.tscn")
var end_loaded := false

onready var sound_manager: SoundManager = $SoundManager

var title_displayed := true
var off_road := false

func _input(event):
  if event.is_action_pressed("ui_accept") && title_displayed:
    title_displayed = false
    ui.hide_title()
    player.activate()
    sound_manager.activate_sfx()
    
  if event.is_action_pressed("fullscreen"):
    OS.window_fullscreen = !OS.window_fullscreen
  if event.is_action_pressed("ui_cancel"):
    OS.window_fullscreen = false

func _ready():
  randomize()

func update_player_position():
  desert_map.update_player_position(player.global_transform.origin)
  sky_exit.global_transform.origin.x = player.global_transform.origin.x
  sky_exit.global_transform.origin.z = player.global_transform.origin.z
  if !off_road:
    off_road = desert_map.is_off_road(player.global_transform.origin)
    if off_road:
      player.boost()


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
  if !glitch_loaded:
    glitch_loaded = true
    
    player.reverse_gravity()
    environment.transition_to(glitch_environment)
    yield(environment, "transition_done")
    
    var glitch: Glitch = glitch_scene.instance()
    add_child(glitch)
    glitch.rotate_z(PI)
    glitch.global_transform.origin = player.global_transform.origin
    glitch.connect("exit", self, "on_exit_glitch")
    
func on_exit_glitch():
  if !end_loaded:
    end_loaded = true
    
    var end: Spatial = end_scene.instance()
    add_child(end)
    end.rotate_z(PI)
    end.global_transform.origin = player.global_transform.origin
    
    environment.transition_to(end_environment, true)
    
    player.dezoom()
    launch_credits()
    
func launch_credits():
  events_timer.wait_time = 10.0
  events_timer.start()
  yield(events_timer, "timeout")
  
  sound_manager.play_credits_music()
  
  events_timer.wait_time = 34.0
  events_timer.start()
  yield(events_timer, "timeout")
  
  ui.show_credits()


