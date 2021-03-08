extends Spatial
class_name SoundManager

var sfx_bus_idx: int
var sfx_amplify: AudioEffectAmplify
var sfx_reverb: AudioEffectReverb

onready var tween: Tween = $Tween
onready var credits_music = $CreditsMusic

func _ready():
  sfx_bus_idx = AudioServer.get_bus_index("SFX")
  sfx_amplify = AudioServer.get_bus_effect(sfx_bus_idx, 0)
  sfx_reverb = AudioServer.get_bus_effect(sfx_bus_idx, 1)
  
func play_credits_music():
  tween.interpolate_property(sfx_amplify, "volume_db",
    0, -50, 25,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(credits_music, "volume_db",
    -35, 0, 20,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.start()
  credits_music.play()
  
func activate_sfx():
  tween.interpolate_property(sfx_amplify, "volume_db",
    -30, 0, 2,
    Tween.TRANS_SINE, Tween.EASE_OUT)
  tween.start()

func activate_reverb():
  AudioServer.set_bus_effect_enabled(sfx_bus_idx, 1, true)
  tween.interpolate_property(sfx_reverb, "room_size",
    0.0, 1.0, 1.5,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.start()
    
func deactivate_reverb():
  tween.interpolate_property(sfx_reverb, "room_size",
    1.0, 0.0, 0.3,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.start()
  yield(tween, "tween_all_completed")
  AudioServer.set_bus_effect_enabled(sfx_bus_idx, 1, false)
  
func mute_motor():
  var idle_bus_idx := AudioServer.get_bus_index("Idle")
  var amplify_idle: AudioEffectAmplify = AudioServer.get_bus_effect(idle_bus_idx, 0)
  tween.interpolate_property(amplify_idle, "volume_db",
    0.0, -50, 3.0,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.start()
