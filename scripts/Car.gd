extends VehicleBody
class_name Car

onready var camera: MouseCamera = $CameraTarget/Camera
onready var target: Spatial = $CameraTarget

const STEER_SPEED = 1
const STEER_LIMIT = 0.1

var steer_target = 0

export(float) var engine_force_value := 30
export(float) var air_resistance := 1.0
export(float) var air_boost := 400.0;

export(Array, NodePath) var wheels := []

func _physics_process(delta):
  var fwd_mps = transform.basis.xform_inv(linear_velocity).y

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
  
func _input(event):
  var test := camera.get_lateral_direction()
  if event.is_action_pressed("steer_left") || event.is_action_pressed("steer_right"):
    var on_ground := false
    for wheel_path in wheels:
      var wheel: VehicleWheel = get_node(wheel_path)
      on_ground = wheel.is_in_contact()
      if on_ground:
        break
    # Air control
    if !on_ground:
      var direction := camera.get_lateral_direction()
      if event.is_action_pressed("steer_left"):
        direction = - direction
      direction.y = 0.3;
      var impulse := direction.normalized() *  air_boost
      apply_central_impulse(impulse)
  
func deactivate_gravity():
  gravity_scale = -0.06
  
func reverse_gravity():
  gravity_scale = -10
