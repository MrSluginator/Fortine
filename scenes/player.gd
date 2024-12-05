extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8.5
const TILE_SIZE = 2
const STRENGTH = 400.0

var moving = false
var direction = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("kick") and $InteractRay.is_colliding():
		var collider:Node3D = $InteractRay.get_collider()
		if collider is RigidBody3D:
			collider.apply_force(direction * STRENGTH)
			print(collider.linear_velocity)
	
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
	if(not input_dir):
		velocity = Vector3(0, velocity.y, 0)
	else:
		velocity = Vector3(0, velocity.y, 0) + direction * SPEED
	
	$InteractRay.target_position = direction
	
	move_and_slide()
	if pow(velocity.x, 2) + pow(velocity.z, 2) < 0.1:
		position.x = roundf(position.x)
		position.z = roundf(position.z)
		velocity = velocity * Vector3(0, 1, 0)



func move():
	if direction:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position.y", 0, 0)
			tween.tween_property(self, "position", position + direction * TILE_SIZE, 0.35)
			tween.tween_callback(done_move)

func jump():
	if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + Vector3.UP * TILE_SIZE, 0.1)
			tween.tween_callback(done_move)

func done_move():
	velocity = Vector3.ZERO
