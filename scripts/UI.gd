extends Control
class_name UI

onready var timer: Timer = $Timer
onready var tween: Tween = $Tween

onready var credits: Control = $Credits
onready var title: Control = $Title
onready var red_background: ColorRect = $RedBg
onready var controls: Control = $Controls

export(float) var credit_slide_duration := 6.0
export(float) var credit_slide_interval = 1.0

func hide_title():
  tween.interpolate_property(title, "modulate",
    Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 1,
    Tween.TRANS_SINE, Tween.EASE_IN)
  tween.start()
  
  yield(tween, "tween_all_completed")
  
  timer.wait_time = 0.8
  timer.start()
  yield(timer, "timeout")
  show_controls()

func show_credits():
  credits.visible = true
  var nb_slides := credits.get_child_count()
  
  for i in range(nb_slides):
    var slide: Control = credits.get_child(i)
    slide.visible = true
    
    if i < nb_slides - 1:
      timer.wait_time = credit_slide_duration
      timer.start()
      yield(timer, "timeout")
      slide.visible = false
      timer.wait_time = credit_slide_interval
      timer.start()
      yield(timer, "timeout")
      
  red_background.visible = true
  tween.interpolate_property(red_background, "modulate",
    red_background.modulate, Color(1.0,1.0,1.0,1.0), 15,
    Tween.TRANS_SINE, Tween.EASE_IN)
  tween.start()

func show_controls():
  controls.visible = true
  
  var screens := controls.get_children()
  var fade := 1.0
  for screen in screens:
    tween.interpolate_property(screen, "modulate",
      Color(1,1,1,0.0), Color(1,1,1,1.0), fade,
      Tween.TRANS_SINE, Tween.EASE_OUT)
    tween.start()
    yield(tween, "tween_all_completed")
    
    timer.wait_time = 4.0
    timer.start()
    yield(timer, "timeout")
    
    tween.interpolate_property(screen, "modulate",
      Color(1,1,1,1.0), Color(1,1,1,0.0), fade,
      Tween.TRANS_SINE, Tween.EASE_OUT)
    tween.start()
    yield(tween, "tween_all_completed")
    
    timer.wait_time = 0.5
    timer.start()
    yield(timer, "timeout")
    
  controls.visible = false
