extends Node

#used for upgrade texture (instansiating new upgradeResources)
const UPGRADE_SLOT_AXE = preload("res://assets/UI/upgrade_slot_axe.png")
const UPGRADE_SLOT_INVENTORY = preload("res://assets/UI/upgrade_slot_inventory.png")
const UPGRADE_SLOT_MOVESPEED = preload("res://assets/UI/upgrade_slot_movespeed.png")
const UPGRADE_SLOT_ARCHER = preload("res://assets/UI/upgrade_slot_archer.png")

const damage_string : String = 'DMG+'
const speed_string : String = 'SPEED+'
const inventory_string : String = 'INV+'

signal upgrade_applied

#current player stats
var player_move_speed : int = 9 * 1000 #9
var player_sprint_multiplier : float  = 1.3 #1.3
var player_inventory_size : int = 9 #9

#var player_attack_damage #TODO refactor this in player, enemy and tree
#var player_attack_speed  #TODO refactor this in player

#upgrade_archer_damage #TODO
#var upgrade_archer_attackspeed #TODO

enum UPGRADE_VARIABLE {
	PLAYER_MOVE_SPEED,
	PLAYER_SPRINT_MULTIPLIER,
	PLAYER_INVENTORY_SIZE
}

func _ready() -> void:
	
	fill_upgrade_lists()

func fill_upgrade_lists()->void:
	#player attack damage
	upgrade_player_damage.push_back(upgrade_player_attack1)
	
	#player attack speed
	upgrade_player_attackspeed.push_back(upgrade_player_attackspeed1)
	
	#player movespeed
	upgrade_player_movespeed.push_back(upgrade_player_movespeed1)
	upgrade_player_movespeed.push_back(upgrade_player_movespeed2)
	
	
func apply_upgrade(upgrade: UpgradeResource) -> void:
	match upgrade.upgrade_variable:
		"player_move_speed":
			player_move_speed += upgrade.upgrade_amount
			print(upgrade_player_movespeed)
			upgrade_player_movespeed.erase(upgrade)
			print(upgrade_player_movespeed)
		"player_inventory_size":
			player_inventory_size += upgrade.upgrade_amount
	
	#TODO remove this upgrade from the responding upgrade list
	emit_signal("upgrade_applied")

#player Axe attack damage
var upgrade_player_damage : Array[UpgradeResource]
var upgrade_player_attack1 : UpgradeResource = UpgradeResource.new(damage_string, 12, UPGRADE_SLOT_AXE, 'test', 1)


#player axe speed
var upgrade_player_attackspeed : Array[UpgradeResource]
var upgrade_player_attackspeed1 : UpgradeResource = UpgradeResource.new(speed_string, 10, UPGRADE_SLOT_AXE, 'test', 1)


#player movespeed
var upgrade_player_movespeed : Array[UpgradeResource]
var upgrade_player_movespeed1 : UpgradeResource = UpgradeResource.new(speed_string, 5, UPGRADE_SLOT_MOVESPEED, 'player_move_speed', 5000)
var upgrade_player_movespeed2 : UpgradeResource = UpgradeResource.new(speed_string, 15, UPGRADE_SLOT_MOVESPEED, 'player_move_speed', 5000)


#player inventory size
var upgrade_player_inventory_size : Array[UpgradeResource]
var upgrade_player_inventory : UpgradeResource = UpgradeResource.new(inventory_string, 30, UPGRADE_SLOT_INVENTORY, 'player_inventory_size', 1)


#maybe have a special upgrade list (sprint, movespeed, roll, ect.)


#var upgrade_archer_damage : Array[UpgradeResource] #TODO
#var upgrade_archer_attackspeed : Array[UpgradeResource] #TODO

func get_next_upgrades() -> Array[UpgradeResource]:
	#this method us used from blacksmith, to get the next in order upgrades
	var upgrades : Array[UpgradeResource]
	#TODO do this smarter - should maybe iterate through all upgrades and chose the cheapest ones
	upgrades.push_front(upgrade_player_damage.front())
	upgrades.push_front(upgrade_player_attackspeed.front())
	upgrades.push_front(upgrade_player_movespeed.front())
	
	return upgrades
