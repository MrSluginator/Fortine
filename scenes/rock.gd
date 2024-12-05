extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if pow(linear_velocity.x, 2) + pow(linear_velocity.z, 2) < 0.1:
		position.x = roundf(position.x)
		position.z = roundf(position.z)
		linear_velocity = linear_velocity * Vector3(0, 1, 0)
