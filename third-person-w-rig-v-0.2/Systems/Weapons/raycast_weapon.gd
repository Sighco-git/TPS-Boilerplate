extends Node3D
class_name RaycastWeapon

@export var equiped_weapon = WeaponData
@onready var max_ammo = equiped_weapon.mag_size
@onready var current_ammo = max_ammo
var bullet_raycast # to stop errors

func _ready() -> void:
	current_ammo = max_ammo

# Reloading
func reload():
	current_ammo = max_ammo

# Shooting
func shoot():
	if current_ammo > 0:
		get_col_points()
		spend_round()
	# func shoot() collision logic
func get_col_points() -> void:
	bullet_raycast.force_raycast_update()
	if bullet_raycast.is_colliding():
		var spawn_point = bullet_raycast.get_collision_point()
		var collider = bullet_raycast.get_collider()
		print("Shot landed at ", spawn_point)
		if collider.is_in_group("enemy"):
			print("Enemy Shot")
			collider.enemy.take_damage()
	# Subtract one round after firing.
func spend_round():
	current_ammo -= 1
	print(current_ammo, " rounds remaining.")
	if current_ammo < 1:
		print("No ammo!")
