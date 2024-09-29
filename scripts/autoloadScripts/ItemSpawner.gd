extends Node

#class_name ItemSpawner
@onready var item_node = preload("res://scenes/itemNode.tscn")

#items
const LOG_RESOURCE = preload("res://scenes/items/log.tres")
const COIN_RESOURCE = preload("res://scenes/items/coin.tres")
enum ITEM {LOG, COIN}

func get_item(item: ITEM) -> ItemNode:
	# Instantiate the ItemNode
	var new_item : ItemNode = item_node.instantiate()
	
	# Ensure new_item is not null
	assert(new_item != null, "Failed to instantiate ItemNode")

	# Apply random impulse for movement
	var random_direction = Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()
	var impulse = random_direction * 150  # Adjust for stronger or weaker ejection
	new_item.apply_central_impulse(impulse)
	
	# Assign the correct resource based on the item type
	match item:
		ITEM.LOG:
			new_item.initialize(LOG_RESOURCE)
		ITEM.COIN:
			new_item.initialize(COIN_RESOURCE, audio.COIN_DROPPED_LIST.pick_random())
	
	return new_item
