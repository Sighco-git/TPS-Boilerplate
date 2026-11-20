extends CharacterBody3D

var speed = 5.0
const JUMP_VELOCITY = 4.5

# Stores x/y direction player is trying to look in.
var _look := Vector2.ZERO

@export var mouse_sensitivity: float = 0.00075
@export var min_boundary: float = -60
@export var max_boundary: float = 10
@export var animation_decay: float = 20.0

@onready var weapon_manager: Node3D = $WeaponManager

@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var rig_pivot: Node3D = $RigPivot
@onready var rig: Node3D = $RigPivot/Rig
@onready var camera: Camera3D = $SmoothCameraArm/Camera3D
@onready var hip_marker: Marker3D = $RigPivot/Rig/Skeleton/HipPivot/HipMarker

func _ready() -> void:
	# Hide cursor and lock within window.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	frame_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := get_movement_direction()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		look_toward_direction(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	weapon_manager.attempt_aim_down_sights()
	weapon_manager.attempt_shoot()
	weapon_manager.attempt_reload()
	turn_in_place(delta)
	look_with_camera()
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	# Reveal and release mouse from window.
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Only allow looking while mouse is captured.
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# Update _look Vector2 with mouse movement's.
			_look += -event.relative * mouse_sensitivity
			
func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_vector = Vector3(input_dir.x, 0, input_dir.y).normalized()
	return horizontal_pivot.global_transform.basis * input_vector
			
func frame_camera_rotation() -> void:
	horizontal_pivot.rotate_y(_look.x)
	vertical_pivot.rotate_x(_look.y)
	# Set limit on how much camera can vertically rotate.
	vertical_pivot.rotation.x = clampf(
	vertical_pivot.rotation.x, deg_to_rad(
	min_boundary), deg_to_rad(max_boundary)
	)
	# Resets look variable when mouse isn't moving
	_look = Vector2.ZERO
	
func look_toward_direction(direction: Vector3, delta: float) -> void:
	var target_transform := rig_pivot.global_transform.looking_at(
		rig_pivot.global_position + direction, 
		Vector3.UP, true
		)
	rig_pivot.global_transform = rig_pivot.global_transform.interpolate_with(
		target_transform,
		1.0 - exp(-animation_decay * delta) # Framerate independent rig turning.
	)

func look_with_camera() -> void:
	var aim_direction = -camera.global_basis.z
	hip_marker.global_position = camera.global_position + aim_direction * 20.0

func turn_in_place(delta: float) -> void: 
	var character_forward = -rig_pivot.global_basis.z
	character_forward.y = 0
	
	var camera_center = -camera.global_basis.z
	camera_center.y = 0
	camera_center = camera_center.normalized()
	
	var angle = rad_to_deg(character_forward.signed_angle_to(camera_center, Vector3.UP))
	
	if abs(angle) > 65.0 || abs(angle) < -65.0:
		look_toward_direction(camera_center.normalized(), delta)
