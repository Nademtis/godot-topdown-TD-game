extends Node

#used for upgrade texture (instansiating new upgradeResources)
const UPGRADE_SLOT_AXE = preload("res://assets/UI/upgrade_slot_axe.png")
const UPGRADE_SLOT_INVENTORY = preload("res://assets/UI/upgrade_slot_inventory.png")
const UPGRADE_SLOT_MOVESPEED = preload("res://assets/UI/upgrade_slot_movespeed.png")
const UPGRADE_SLOT_ARCHER = preload("res://assets/UI/upgrade_slot_archer.png")

const damage_string : String = 'DMG+'
const speed_string : String = 'SPEED+'
const inventory_string : String = 'INV+'

@warning_ignore("unused_signal")
signal upgrade_applied

#current player stats
var player_move_speed : int = 9 * 1000 #9
var player_sprint_multiplier : float = 1.3 #1.3
var player_inventory_size : int = 9 #9

var player_attack_damage : float = 1.0 #1.0
var player_attack_speed : float = 0.3 # 0.3

var player_archer_damage : float = 1.0 #1.0
var player_archer_attackspeed : float = 0.7 # 0.7

func apply_upgrade(upgrade: UpgradeResource) -> void:
	match upgrade.upgrade_variable:
		"player_move_speed":
			player_move_speed += int(upgrade.upgrade_amount)
			upgrade_player_movespeed.erase(upgrade)
		"player_inventory_size": #TODO remove this upgrade from the responding upgrade list
			player_inventory_size += int(upgrade.upgrade_amount)
		"player_attack_damage":
			player_attack_damage += upgrade.upgrade_amount
			upgrade_player_damage.erase(upgrade)
		"player_attack_speed":
			player_attack_speed -= upgrade.upgrade_amount
			upgrade_player_attackspeed.erase(upgrade)
		"player_archer_damage":
			player_archer_damage += upgrade.upgrade_amount
			upgrade_archer_damage.erase(upgrade)
		"player_archer_attackspeed":
			player_archer_attackspeed -= upgrade.upgrade_amount
			upgrade_archer_attackspeed.erase(upgrade)
	
	emit_signal("upgrade_applied")

#player Axe attack damage
var upgrade_player_damage : Array[UpgradeResource] = [
	UpgradeResource.new(damage_string, 12, UPGRADE_SLOT_AXE, 'player_attack_damage', 1)
	
]

#player axe speed
var upgrade_player_attackspeed : Array[UpgradeResource] = [
	UpgradeResource.new(speed_string, 10, UPGRADE_SLOT_AXE, 'player_attack_speed', 0.1),
	
]

#player movespeed
var upgrade_player_movespeed : Array[UpgradeResource] = [
UpgradeResource.new(speed_string, 5, UPGRADE_SLOT_MOVESPEED, 'player_move_speed', 5000),
UpgradeResource.new(speed_string, 15, UPGRADE_SLOT_MOVESPEED, 'player_move_speed', 5000),
	
]

#player inventory size
var upgrade_player_inventory_size : Array[UpgradeResource] = [
	UpgradeResource.new(inventory_string, 30, UPGRADE_SLOT_INVENTORY, 'player_inventory_size', 1),
	
]
#archer damage
var upgrade_archer_damage : Array[UpgradeResource] = [
	UpgradeResource.new(damage_string, 20, UPGRADE_SLOT_ARCHER, 'player_archer_damage', 0.5),
]

#archer attack_speed
var upgrade_archer_attackspeed : Array[UpgradeResource] = [
	UpgradeResource.new(speed_string, 15, UPGRADE_SLOT_ARCHER, 'player_archer_attackspeed', 0.1),
]

func get_next_upgrades() -> Array[UpgradeResource]:
	var all_upgrades : Array[UpgradeResource] = []

	# Combine all upgrade lists into one
	all_upgrades += upgrade_player_damage
	all_upgrades += upgrade_player_attackspeed
	all_upgrades += upgrade_player_movespeed
	#all_upgrades += upgrade_player_inventory_size
	all_upgrades += upgrade_archer_damage
	all_upgrades += upgrade_archer_attackspeed

	all_upgrades.sort_custom(Callable(self, "_sort_by_cost"))

	# Return the first three cheapest upgrades, or fewer if less are available
	return all_upgrades.slice(0, 3)

# Custom sorting function
func _sort_by_cost(a: UpgradeResource, b: UpgradeResource) -> bool:
	return a.price < b.price
