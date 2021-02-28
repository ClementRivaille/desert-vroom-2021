extends WorldEnvironment
class_name AdaptiveEnvironment

signal transition_done

onready var tween: Tween = $Tween

var TRANSITION_DURATION := 1.0

func transition_to(env: Environment):
  var target_sky: ProceduralSky = env.background_sky
  var current_sky: ProceduralSky = environment.background_sky
  # Colors
  interpolate_sky("sky_top_color", target_sky)
  interpolate_sky("sky_horizon_color", target_sky)
  interpolate_sky("ground_bottom_color", target_sky)
  interpolate_sky("ground_horizon_color", target_sky)
    
  # Sun
  interpolate_sky("sun_energy", target_sky)
  interpolate_sky("sun_color", target_sky)
  interpolate_sky("sun_latitude", target_sky)
  interpolate_sky("sun_longitude", target_sky)
  interpolate_sky("sun_curve", target_sky)
    
  tween.start()

  environment.fog_enabled = env.fog_enabled
  tween.interpolate_property(environment, "fog_color",
    environment.fog_color, env.fog_color,
    TRANSITION_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    
  environment.background_sky_orientation = env.background_sky_orientation
  
func interpolate_sky(property: String, target_sky: ProceduralSky):
  var current_sky: ProceduralSky = environment.background_sky
  tween.interpolate_property(current_sky, property,
    current_sky[property], target_sky[property],
    TRANSITION_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func on_transition_complete():
  emit_signal("transition_done")
