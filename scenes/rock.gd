extends RigidBody3D

@export var health:Health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	pass


func death() -> void:
	# death animation
	apply_central_impulse(Vector3.UP * 10)
	await get_tree().create_timer(1.0).timeout
	queue_free()
