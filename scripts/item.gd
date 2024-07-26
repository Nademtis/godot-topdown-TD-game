class_name Item
extends Node

@export var item_name : String
@export var weight : int 

func picked_up():
	queue_free()

