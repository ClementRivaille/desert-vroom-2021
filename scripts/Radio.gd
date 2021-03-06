extends AudioStreamPlayer
class_name Radio

var active := false

onready var fx: AudioStreamPlayer = $FX

export(AudioStream) var radio_start: AudioStream
export(AudioStream) var radio_stop: AudioStream
export(AudioStream) var radio_glitch: AudioStream
export(AudioStream) var radio_out: AudioStream

export(AudioStream) var channel_2: AudioStream

var radio_bus_idx := 0

func _ready():
  radio_bus_idx = AudioServer.get_bus_index("Radio")
  AudioServer.set_bus_mute(radio_bus_idx, true)
  play(randf()*10.0)

func _input(event):
  if active && event.is_action_pressed("radio") && !fx.playing:
    var mute = AudioServer.is_bus_mute(radio_bus_idx)
    fx.stream = radio_start if mute else radio_stop
    fx.pitch_scale = 0.95 + randf() * 0.1
    fx.play()
    yield(fx, "finished")
    AudioServer.set_bus_mute(radio_bus_idx, !mute)
    
func switch_channel():
  var mute = AudioServer.is_bus_mute(radio_bus_idx)
  var position := get_playback_position()
  stop()
  stream = radio_glitch
  play()
  yield(self, "finished")
  stream =  channel_2
  play(position)
  
func turn_off():
  active = false
  stop()
  stream = radio_out
  play()
