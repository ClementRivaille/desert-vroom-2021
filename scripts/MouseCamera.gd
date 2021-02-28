extends Spatial
class_name MouseCamera

var mouse_sensitivity := 0.003

onready var gimbal: Spatial = $Gimbal
onready var camera: Camera = $Gimbal/Camera
onready var tween: Tween = $Tween

export(float) var dezoom_length := 80.0

var x_inverted := false

func _ready():
  set_as_toplevel(true)
  camera.look_at_from_position(camera.global_transform.origin, global_transform.origin, Vector3.UP)
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  
func _input(event):
  if event is InputEventMouseMotion:
    if event.relative.x != 0:
      var invert := 1 if !x_inverted else -1
      rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity * invert)
    if event.relative.y != 0:
      gimbal.rotate_object_local(Vector3.RIGHT, -event.relative.y * mouse_sensitivity)

  if event.is_action_pressed("ui_cancel"):
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  if event.is_action_pressed("click") && Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_lateral_direction() -> Vector3:
  return camera.global_transform.basis.x

func dezoom():
  camera.projection = Camera.PROJECTION_ORTHOGONAL
  camera.far = 3000
  camera.transform.origin.z = -1500
  
  tween.interpolate_property(camera, "size",
    camera.size, 3000, dezoom_length,
    Tween.TRANS_SINE, Tween.EASE_IN)
  tween.start()
