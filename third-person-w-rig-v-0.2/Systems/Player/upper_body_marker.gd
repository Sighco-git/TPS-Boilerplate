extends Marker3D

@onready var upper_body_marker = $Skeleton3D/LookAtModifier3D/UpperBodyMarker
@export var camera: Camera3D

func _process(delta: float) -> void:
	# Place the marker far ahead of where the camera is aiming
	var aim_origin = camera.global_position
	var aim_dir = -camera.global_basis.z  # forward vector
	upper_body_marker.global_position = aim_origin + aim_dir * 20.0
