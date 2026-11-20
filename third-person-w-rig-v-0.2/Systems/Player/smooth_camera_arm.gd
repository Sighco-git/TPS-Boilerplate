extends SpringArm3D

@export var target: Node3D
@export var decay: float = 20.0 # Lower is slower, Higher is snappier
@export var camera_y_offset: float = 2.0 # Higher raises camera more.

func _physics_process(delta: float) -> void:
	global_transform = global_transform.interpolate_with(
		target.global_transform, 
		1.0 - exp(-decay * delta)
	)
	global_position.y += camera_y_offset
