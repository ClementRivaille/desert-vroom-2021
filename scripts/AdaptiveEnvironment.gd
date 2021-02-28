extends WorldEnvironment
class_name AdaptiveEnvironment

signal transition_done

onready var tween: Tween = $Tween

var TRANSITION_DURATION := 0.4

func transition_to(env: Environment):
  var target_sky: ProceduralSky = env.background_sky
  var current_sky: ProceduralSky = environment.background_sky
  # Colors
  tween.interpolate_property(current_sky, "sky_top_color",
    current_sky.sky_top_color, target_sky.sky_top_color,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(current_sky, "sky_horizon_color",
    current_sky.sky_horizon_color, target_sky.sky_horizon_color,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(current_sky, "ground_bottom_color",
    current_sky.ground_bottom_color, target_sky.ground_bottom_color,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(current_sky, "ground_horizon_color",
    current_sky.ground_horizon_color, target_sky.ground_horizon_color,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    
  # Sun
  tween.interpolate_property(current_sky, "sun_energy",
    current_sky.sun_energy, target_sky.sun_energy,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(current_sky, "sun_color",
    current_sky.sun_color, target_sky.sun_color,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(current_sky, "sun_latitude",
    current_sky.sun_latitude, target_sky.sun_latitude,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(current_sky, "sun_longitude",
    current_sky.sun_longitude, target_sky.sun_longitude,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.interpolate_property(current_sky, "sun_curve",
    current_sky.sun_curve, target_sky.sun_curve,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    
  tween.start()

  environment.fog_enabled = env.fog_enabled
  tween.interpolate_property(environment, "fog_color",
    environment.fog_color, env.fog_color,
    TRANSITION_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)


func on_transition_complete():
  emit_signal("transition_done")
