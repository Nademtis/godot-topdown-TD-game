extends Node

class_name Hubprogression

enum HUB_UPGRADE {
	PLAYER_CAMPFIRE,
	PLAYER_TENT,
	BRIDGE1,
	BLACKSMITH_TENT,
	}

#what player has unlocked so far
var hub_upgrade_status = {
	HUB_UPGRADE.PLAYER_CAMPFIRE : false,
	HUB_UPGRADE.PLAYER_TENT : false,
	HUB_UPGRADE.BRIDGE1 : false,
	HUB_UPGRADE.BLACKSMITH_TENT : false,
}

var recipe_player_campfire : Array[ItemResource]
var recipe_player_tent : Array[ItemResource]
var recipe_bridge1 : Array[ItemResource]
var recipe_blacksmith_tent : Array[ItemResource]

#list of recepies
var build_recipe_dic = {
	HUB_UPGRADE.PLAYER_CAMPFIRE : recipe_player_campfire,
	HUB_UPGRADE.PLAYER_TENT : recipe_player_tent,
	HUB_UPGRADE.BRIDGE1 : recipe_bridge1,
	HUB_UPGRADE.BLACKSMITH_TENT : recipe_blacksmith_tent,
}

var current_upgrade_deposit_amount : int = 0


func _ready() -> void:
	init_upgrade_recipies()

func init_upgrade_recipies() -> void:
	var log = ItemSpawner.LOG_RESOURCE
	recipe_player_campfire = create_recipe(log, 3)
	recipe_player_tent = create_recipe(log, 5)
	recipe_bridge1 = create_recipe(log, 8)
	recipe_blacksmith_tent = create_recipe(log, 5)

func hub_upgrade_finished(hub_upgrade : HUB_UPGRADE) -> void:
	hub_upgrade_status[hub_upgrade] = true
	var main : Level = get_tree().current_scene
	main.update_hub_upgrade_nodes()
	pass

func create_recipe(item: ItemResource, count: int) -> Array[ItemResource]:
	var recipe : Array[ItemResource] = []
	recipe.resize(count)
	recipe.fill(item)
	return recipe
