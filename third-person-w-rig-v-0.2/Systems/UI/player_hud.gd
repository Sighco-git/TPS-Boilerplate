extends Control

func _ready() -> void:
	$AmmoCount.text = "Ammo: Full"

func _on_weapon_manager_update_ammo(current_ammo: Variant) -> void:
	$AmmoCount.text = "Ammo: " + str(current_ammo)
