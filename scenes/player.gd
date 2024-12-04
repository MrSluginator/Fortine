extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const TILE_SIZE = 2

var moving = false
var direction


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("up-left", "down-right", "up-right", "down-left")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	move()

func move():
	if direction:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + direction * TILE_SIZE, 0.35)
			tween.tween_callback(done_move)

func done_move():
	moving = false
