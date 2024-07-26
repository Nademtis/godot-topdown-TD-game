extends Node2D

var hp = 3
@onready var log_path = preload("res://scenes/log.tscn")

func _on_area_2d_area_entered(area):
	if area.is_in_group("attack"):
		take_damage()
	pass # Replace with function body.

func take_damage():
		hp = hp - 1
		if hp < 1:
			die()
		pass

func die():
	#spawn item
	var log_item = log_path.instantiate()
	var item_container = get_tree().root.get_node("main").get_node("Items")
	log_item.position = position
	#get_tree().root.print_tree_pretty()
	if item_container:
		item_container.call_deferred("add_child", log_item)
	else:
		print("no item container in root")
	call_deferred("queue_free") # call after a psysics/process frame 
	
