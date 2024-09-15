extends Area2D

var inventory : Array[ItemResource] = PlayerInventory.player_inventory

@onready var ui: CanvasLayer


func _ready():
	ui = get_tree().root.get_node("main/UI")
	ui.player_inventory_ui.update_inventory_UI()
	
func _process(_delta):
	pass


func _on_area_entered(area : Area2D):
	if area.is_in_group("item"):
		var itemNode : ItemNode = area.get_parent()
		
		if (itemNode.item_resource.name == 'coin'):
			PlayerInventory.add_coin()
			itemNode.picked_up()
			ui.update_coins_ui()
			
		elif (PlayerInventory.player_inventory.size() < PlayerStats.player_inventory_size):
			inventory.push_front(itemNode.item_resource)
			itemNode.picked_up() # removes item drop
			
			#inform UI
			ui.player_inventory_ui.update_inventory_UI()
	
	if area.is_in_group("blueprint"):
		#area.get_parent().deposit_item(inventory)
		pass
