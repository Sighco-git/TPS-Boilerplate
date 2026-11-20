extends Node

# References
@onready var right_hand: Marker3D = $"../RigPivot/Rig/Skeleton/RightHand/AnchorPoint"
@onready var camera: Camera3D = $"../SmoothCameraArm/Camera3D"
@export var equiped_weapon: RaycastWeapon
#  Signals
signal update_ammo(current_ammo)
	
func attempt_aim_down_sights() -> void:
	var ads_fov = 45.0
	var defualt_fov = 75.0
	if Input.is_action_pressed("alt_use_equiped"):
		camera.fov = lerp(camera.fov, ads_fov, 0.5)
	else:
		camera.fov = lerp(camera.fov, defualt_fov, 0.5)
		
func attempt_shoot():
	if Input.is_action_just_pressed("use_equiped"):
		equiped_weapon.shoot()
		update_ammo.emit(equiped_weapon.current_ammo)
	pass
	
func attempt_reload():
	if Input.is_action_just_pressed("reload"):
		equiped_weapon.reload()
		print("Reloading...")
		update_ammo.emit(equiped_weapon.current_ammo)
		pass
