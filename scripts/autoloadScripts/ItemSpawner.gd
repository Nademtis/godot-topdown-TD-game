extends Node

#class_name ItemSpawner
@onready var item_node = preload("res://scenes/itemNode.tscn")


const LOG_RESOURCE = preload("res://scenes/items/log.tres")
const COIN_RESOURCE = preload("res://scenes/items/coin.tres")

enum ITEM {LOG, COIN}



func get_item(item : ITEM) -> ItemNode:
	var new_item : ItemNode = item_node.instantiate()
	match item:
		ITEM.LOG:
			new_item.initialize(LOG_RESOURCE)
		ITEM.COIN:
			new_item.initialize(COIN_RESOURCE)
	return new_item
