extends Control
class_name UI

onready var timer: Timer = $Timer
onready var tween: Tween = $Tween

onready var credits: Control = $Credits

export(float) var credit_slide_duration := 6.0
export(float) var credit_slide_interval = 1.0

func show_credits():
  credits.visible = true
  var nb_slides := credits.get_child_count()
  
  for i in range(nb_slides):
    var slide: Control = credits.get_child(i)
    slide.visible = true
    timer.wait_time = credit_slide_duration
    timer.start()
    yield(timer, "timeout")
    
    if i < nb_slides - 1:
      slide.visible = false
      timer.wait_time = credit_slide_interval
      timer.start()
      yield(timer, "timeout")
