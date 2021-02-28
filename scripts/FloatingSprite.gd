extends Spatial
class_name FloatingSprite

export(float) var max_speed := 30.0

onready var speed := randf() * max_speed
onready var direction := Vector3(- 1 + randf() * 2, -0.5 + randf() * 1, -1 + randf() * 2).normalized()

func _physics_process(delta):
  transform.origin += direction * speed * delta
