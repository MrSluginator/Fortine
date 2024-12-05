extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8.5
const TILE_SIZE = 2

var moving = false
var direction


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

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
	if(not input_dir):
		direction = Vector3.ZERO
	elif (input_dir.length() == 1):
		direction = Vector3(input_dir.x, 0, input_dir.y)

	move()


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
	moving = false
