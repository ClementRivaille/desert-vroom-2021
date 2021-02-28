extends Spatial
class_name SoundManager

var sfx_amplify: AudioEffectAmplify

onready var tween: Tween = $Tween
onready var credits_music = $CreditsMusic

func _ready():
  var sfx_bus_idx = AudioServer.get_bus_index("SFX")
  sfx_amplify = AudioServer.get_bus_effect(sfx_bus_idx, 0)
  
func play_credits_music():
  tween.interpolate_property(sfx_amplify, "volume_db",
    0, -50, 25,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(credits_music, "volume_db",
    -25, 0, 20,
    Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.start()
  credits_music.play()
  
func activate_sfx():
  tween.interpolate_property(sfx_amplify, "volume_db",
    -30, 0, 2,
    Tween.TRANS_SINE, Tween.EASE_OUT)
  tween.start()
