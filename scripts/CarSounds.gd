extends Spatial
class_name CarSounds

onready var idle: AudioStreamPlayer = $Idle
onready var engine: AudioStreamPlayer = $Engine
onready var crash: AudioStreamPlayer = $Crash

onready var tween: Tween = $Tween

export(Array, AudioStream) var light_crashes := []
export(Array, AudioStream) var loud_crashes := []

var min_scale := 0.2
var max_speed := 120.0

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
  if speed > 0:
    var value := speed / max_speed
    engine.pitch_scale = lerp(min_scale, 1.0, value)
  elif engine.pitch_scale > min_scale:
    engine.pitch_scale = max(min_scale, engine.pitch_scale * 0.99)
  
func play_crash(loud: bool):
  if crash.playing:
    return

  var sounds: Array = light_crashes if !loud else loud_crashes
  var stream: AudioStream = sounds[randi()%sounds.size()]
  
  crash.stream = stream
  crash.pitch_scale = 1.0 - 0.4 + randf() * 0.8 if !loud else 1.0 + randf()*0.2
  crash.play()
