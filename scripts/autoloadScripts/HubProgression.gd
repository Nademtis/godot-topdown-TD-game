extends Node

class_name Hubprogression

enum HUB_UPGRADE {
	PLAYER_CAMPFIRE,
	PLAYER_TENT,
	BRIDGE1,
	BLACKSMITH_TENT,
}

# What player has unlocked so far
var hub_upgrade_status = {
	HUB_UPGRADE.PLAYER_CAMPFIRE: false,
	HUB_UPGRADE.PLAYER_TENT: false,
	HUB_UPGRADE.BRIDGE1: false,
	HUB_UPGRADE.BLACKSMITH_TENT: false,
}

var recipe_player_campfire: Array[ItemResource]
var recipe_player_tent: Array[ItemResource]
var recipe_bridge1: Array[ItemResource]
var recipe_blacksmith_tent: Array[ItemResource]

# List of recipes
var build_recipe_dic: Dictionary
var build_recipe_original_price : Dictionary

func _ready() -> void:
	init_upgrade_recipies()

func init_upgrade_recipies() -> void:
	var log_item = ItemSpawner.LOG_RESOURCE
	recipe_player_campfire = create_recipe(log_item, 3)
	recipe_player_tent = create_recipe(log_item, 5)
	recipe_bridge1 = create_recipe(log_item, 8)
	recipe_blacksmith_tent = create_recipe(log_item, 5)
	
	build_recipe_dic = {
		HUB_UPGRADE.PLAYER_CAMPFIRE: recipe_player_campfire,
		HUB_UPGRADE.PLAYER_TENT: recipe_player_tent,
		HUB_UPGRADE.BRIDGE1: recipe_bridge1,
		HUB_UPGRADE.BLACKSMITH_TENT: recipe_blacksmith_tent,
	}
	build_recipe_original_price = {
		HUB_UPGRADE.PLAYER_CAMPFIRE: recipe_player_campfire.size(),
		HUB_UPGRADE.PLAYER_TENT: recipe_player_tent.size(),
		HUB_UPGRADE.BRIDGE1: recipe_bridge1.size(),
		HUB_UPGRADE.BLACKSMITH_TENT: recipe_blacksmith_tent.size(),
	}

func hub_upgrade_finished(hub_upgrade: HUB_UPGRADE) -> void:
	hub_upgrade_status[hub_upgrade] = true
	var main: Level = get_tree().current_scene
	main.update_hub_upgrade_nodes()

func create_recipe(item: ItemResource, count: int) -> Array[ItemResource]:
	var recipe: Array[ItemResource] = []
	recipe.resize(count)
	recipe.fill(item)
	return recipe
