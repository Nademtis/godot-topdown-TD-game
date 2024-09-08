extends Node

#class_name ItemSpawner
@onready var item_node = preload("res://scenes/itemNode.tscn")

#items
const LOG_RESOURCE = preload("res://scenes/items/log.tres")
const COIN_RESOURCE = preload("res://scenes/items/coin.tres")

enum ITEM {LOG, COIN}

func get_item(item : ITEM) -> ItemNode:
	var new_item : ItemNode = item_node.instantiate()
	
	var random_direction = Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()
	var impulse = random_direction * 150  # Adjust for stronger or weaker ejection
	new_item.apply_central_impulse(impulse)
	
	match item:
		ITEM.LOG:
			new_item.initialize(LOG_RESOURCE)
		ITEM.COIN:
			new_item.initialize(COIN_RESOURCE)
	return new_item
