extends WorldEnvironment
class_name AdaptiveEnvironment

signal transition_done

onready var tween: Tween = $Tween

var TRANSITION_DURATION := 1.2
var LONG_TRANSITION := 30.0

func transition_to(env: Environment, long: bool = false):
  var target_sky: ProceduralSky = env.background_sky
  var current_sky: ProceduralSky = environment.background_sky
  
  var duration := TRANSITION_DURATION if !long else LONG_TRANSITION
  # Colors
  interpolate_sky("sky_top_color", target_sky, duration)
  interpolate_sky("sky_horizon_color", target_sky, duration)
  interpolate_sky("ground_bottom_color", target_sky, duration)
  interpolate_sky("ground_horizon_color", target_sky, duration)
    
  # Sun
  interpolate_sky("sun_energy", target_sky, duration)
  interpolate_sky("sun_color", target_sky, duration)
  interpolate_sky("sun_latitude", target_sky, duration)
  interpolate_sky("sun_longitude", target_sky, duration)
  interpolate_sky("sun_curve", target_sky, duration)
    
  tween.start()

  environment.fog_enabled = env.fog_enabled
  tween.interpolate_property(environment, "fog_color",
    environment.fog_color, env.fog_color,
    duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    
  environment.background_sky_orientation = env.background_sky_orientation
  
func interpolate_sky(property: String, target_sky: ProceduralSky, duration: float):
  var current_sky: ProceduralSky = environment.background_sky
  tween.interpolate_property(current_sky, property,
    current_sky[property], target_sky[property],
    duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func on_transition_complete():
  emit_signal("transition_done")
