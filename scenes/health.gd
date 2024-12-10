class_name Health extends Node

signal health_depleated

var health:float = 10

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hurt(damage: float) -> void:
	health -= damage
	print(health)
	if health <= 0:
		health_depleated.emit()
