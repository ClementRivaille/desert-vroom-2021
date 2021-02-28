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
var air_control_lock := false

var on_ground := true
var accelerating := false

onready var sounds: CarSounds = $Sounds

func _ready():
  sounds.activate()

func _physics_process(delta):
  update_on_ground()
  var fwd_mps = transform.basis.xform_inv(linear_velocity).y

  steer_target = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
  steer_target *= STEER_LIMIT

  if Input.is_action_pressed("accelerate") || Input.is_action_pressed("brake"):
    engine_force = engine_force_value if Input.is_action_pressed("accelerate") else -engine_force_value
    if !accelerating:
      sounds.change_state(true)
      accelerating = true
  else:
    engine_force = 0
    if accelerating:
      sounds.change_state(false)
      accelerating = false

  steering = move_toward(steering, steer_target, STEER_SPEED * delta)
  
  add_central_force(-linear_velocity * air_resistance)
  # print(linear_velocity.length())
  
  # Camera
  camera.global_transform.origin = target.global_transform.origin
  
  var speed : float = linear_velocity.length() if on_ground else -1
  sounds.update_pitch(speed)
  
func update_on_ground():
  var in_air := !on_ground
  
  on_ground = false
  for wheel_path in wheels:
    var wheel: VehicleWheel = get_node(wheel_path)
    on_ground = wheel.is_in_contact()
    if on_ground:
      break
      
  if in_air && on_ground:
    sounds.play_crash(false)
  
func _input(event):
  if (!air_control_lock &&
    (event.is_action_pressed("steer_left") || event.is_action_pressed("steer_right"))):
    
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
  gravity_scale = -1
  air_control_lock = true
  camera.x_inverted = true
  
func dezoom():
  camera.dezoom()


func _integrate_forces(state : PhysicsDirectBodyState)->void:
  var collision_force := Vector3.ZERO
  for i in range(state.get_contact_count()):
    collision_force += state.get_contact_impulse(i) * state.get_contact_local_normal(i)
  
  var force := collision_force.length()
  if force > 250:
    var loud: bool = false if force < 700 else true
    sounds.play_crash(loud)
