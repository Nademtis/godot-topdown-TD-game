extends Area2D

var inventory : Array[ItemResource] = PlayerInventory.player_inventory

var ui : CanvasLayer

func _ready():
	ui = get_tree().root.get_node("main/UI")
	ui.changeTxt(inventory)

func _process(_delta):
	pass


func _on_area_entered(area : Area2D):
	if area.is_in_group("item"):
		if (PlayerInventory.player_inventory.size() < PlayerStats.player_inventory_size):
			var itemNode : ItemNode = area.get_parent()
			inventory.push_front(itemNode.item_resource)
			itemNode.picked_up() # removes item drop
			
			#inform UI
			ui.changeTxt(inventory)
			ui.player_inventory_ui.update_inventory_UI()
	
	if area.is_in_group("blueprint"):
		#area.get_parent().deposit_item(inventory)
		pass
