extends Node2D



@export var wagon_storage : Array
@onready var label = $Label

var ui : CanvasLayer

var player_is_in_range = false
var player_inventory_array

func _ready():
	ui = get_tree().root.get_node("main/UI")
	update_label()
	pass # Replace with function body.

func update_label():
	label.text = "LOGS: " + str(wagon_storage.size()) + "/" + str(20)

func _input(event):
	if player_is_in_range && event.is_action_pressed("use"):
		player_inventory_array = get_tree().root.get_node("main/Player/itemArea2D").inventory
		for item in player_inventory_array:
			#if item_cost_array.has(item):
			player_inventory_array.erase(item)
			wagon_storage.push_front(item)
			ui.changeTxt(player_inventory_array)
			update_label()
			break

func _on_area_2d_area_entered(area):
	#label.visible = true
	if area.is_in_group("player"):
		#animation_player.play("blink_and_size")
		player_is_in_range = true

func _on_area_2d_area_exited(area):
	#label.visible = false
	if area.is_in_group("player"):
		#animation_player.play("blinkAlpha")
		player_is_in_range = false
