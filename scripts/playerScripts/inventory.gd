extends Area2D

@export var inventory : Array



func _process(_delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("item"):
		#print("picked up: " + str(area.get_parent()))
		inventory.push_front(area.get_parent().name)
		#print(inventory)
		area.get_parent().picked_up() # removes item drop
	
	if area.is_in_group("blueprint"):
		#area.get_parent().deposit_item(inventory)
		pass




#func _on_area_exited(area):
	#if area.is_in_group("blueprint"):
		#is_in_range_of_bp = false
#	pass # Replace with function body.
