extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8.5
const TILE_SIZE = 2
const STRENGTH = 500.0

@export var dash_timer:Timer

var locked = false
var direction = Vector3.FORWARD

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("kick") and $InteractRay.is_colliding():
		var collider:Node3D = $InteractRay.get_collider()
		if collider is RigidBody3D:
			collider.apply_force(direction * STRENGTH)
			collider.health.hurt(1)
	
	if Input.is_action_just_pressed("dash") and not locked:
		velocity += direction * SPEED * 3
		dash_timer.start()
		lock_actions()
	
	if Input.is_action_just_pressed("grab") and $InteractRay.is_colliding():
		var collider:Node3D = $InteractRay.get_collider()
		if collider is RigidBody3D:
			collider.apply_torque(Vector3.UP)
			collider.apply_force((-direction + Vector3.UP) * STRENGTH)
			collider.look_at(position)
			collider.health.hurt(1)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("down-left"):
		direction = Vector3(0, 0, 1)
	elif Input.is_action_just_pressed("down-right"):
		direction = Vector3(1, 0, 0)
	elif Input.is_action_just_pressed("up-left"):
		direction = Vector3(-1, 0, 0)
	elif Input.is_action_just_pressed("up-right"):
		direction = Vector3(0, 0, -1)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("up-left", "down-right", "up-right", "down-left")
	if (input_dir.length() == 1):
		direction = Vector3(input_dir.x, 0, input_dir.y)
	if (not locked):
		if(not input_dir):
			velocity = Vector3(0, velocity.y, 0)
		else:
			velocity = Vector3(0, velocity.y, 0) + direction * SPEED
	
	$InteractRay.target_position = direction * 2
	
	move_and_slide()

func lock_actions():
	locked = true

func unlock_actions():
	locked = false
