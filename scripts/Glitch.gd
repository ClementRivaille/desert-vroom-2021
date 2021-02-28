extends Spatial
class_name Glitch

signal exit

func on_exit(body):
  emit_signal("exit")
