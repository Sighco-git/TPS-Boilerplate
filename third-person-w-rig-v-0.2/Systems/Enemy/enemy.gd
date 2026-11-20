extends Node3D
class_name Enemy

@export var health: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_area_entered(area: Area3D) -> void:
	take_damage()
	
func take_damage() -> void:
	health -= 1
	print("Enemy hits remaining: ", health)
	if health == 0:
		self.queue_free()
