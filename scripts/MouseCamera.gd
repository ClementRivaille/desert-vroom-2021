extends Spatial
class_name MouseCamera

var mouse_sensitivity := 0.003

onready var gimbal: Spatial = $Gimbal
onready var camera: Camera = $Gimbal/Camera

func _ready():
  set_as_toplevel(true)
  camera.look_at_from_position(camera.transform.origin, transform.origin, Vector3.UP)
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  

func _unhandled_input(event):
  if event is InputEventMouseMotion:
    if event.relative.x != 0:
      rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity)
    if event.relative.y != 0:
      gimbal.rotate_object_local(Vector3.RIGHT, -event.relative.y * mouse_sensitivity)

func _input(event):
  if event.is_action_pressed("ui_cancel"):
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  if event.is_action_pressed("click") && Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
