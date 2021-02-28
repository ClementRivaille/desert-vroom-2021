extends Spatial
class_name CarSounds

onready var idle: AudioStreamPlayer = $Idle
onready var engine: AudioStreamPlayer = $Engine
onready var crash: AudioStreamPlayer = $Crash

onready var tween: Tween = $Tween

var min_scale := 0.2
var max_speed := 80.0

var fade_in: float = 0.3
var fade_out: float = 1.0
var low := -50

func _ready():
  idle.volume_db = 0
  engine.volume_db = low
  
  engine.pitch_scale = min_scale
  
func activate():
  idle.play()
  engine.play()

func change_state(running: bool):
  if tween.is_active():
    tween.stop_all()

  var target :AudioStreamPlayer = engine if running else idle
  var previous :AudioStreamPlayer = idle if running else engine
  
  var from := max(target.volume_db, -15)
  tween.interpolate_property(target, "volume_db",
    from, 0, fade_in,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(previous, "volume_db",
    previous.volume_db, low, fade_out,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.start()

func update_pitch(speed: float):
  var value := speed / max_speed
  engine.pitch_scale = lerp(min_scale, 1.0, value)
