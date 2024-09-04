extends Area2D

var inventory : Array[String] = PlayerInventory.player_inventory

var ui : CanvasLayer

func _ready():
	ui = get_tree().root.get_node("main/UI")
	ui.changeTxt(inventory)

func _process(_delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("item"):
		inventory.push_front(area.get_parent().name)
		area.get_parent().picked_up() # removes item drop
		
		#inform UI
		ui.changeTxt(inventory)
	
	if area.is_in_group("blueprint"):
		#area.get_parent().deposit_item(inventory)
		pass
