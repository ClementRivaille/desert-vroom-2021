extends VehicleBody
class_name Car

onready var camera: MouseCamera = $CameraTarget/Camera
onready var target: Spatial = $CameraTarget

const STEER_SPEED = 2
const STEER_LIMIT = 0.1

var steer_target = 0

export(float) var engine_force_value := 30
export(float) var air_resistance := 1.0

func _ready():
  camera.set_as_toplevel(true)

func _physics_process(delta):
  var fwd_mps = transform.basis.xform_inv(linear_velocity).x

  steer_target = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
  steer_target *= STEER_LIMIT

  if Input.is_action_pressed("accelerate"):
    engine_force = engine_force_value
  else:
    engine_force = 0

  if Input.is_action_pressed("brake"):
    if (fwd_mps >= -1):
      engine_force = -engine_force_value
    else:
      brake = 1
  else:
    brake = 0.0

  steering = move_toward(steering, steer_target, STEER_SPEED * delta)
  
  add_central_force(-linear_velocity * air_resistance)
  # print(linear_velocity.length())
  
  # Camera
  camera.global_transform.origin = target.global_transform.origin
