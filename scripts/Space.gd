extends Spatial
class_name Space

signal exit

func on_exit(_body):
  emit_signal("exit")
