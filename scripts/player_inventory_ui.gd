extends Control

#This script should update inventoryUI based on inventory

@onready var ui_panel_list : Array = $NinePatchRect/GridContainer.get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_inventory_UI()
	pass # Replace with function body.


func update_inventory_UI():
	var player_inventory : Array[ItemResource] = PlayerInventory.player_inventory
	for i in range(min(player_inventory.size(), ui_panel_list.size())):
		ui_panel_list[i].update(player_inventory[i])
	pass
