extends Node2D

@export var wagon_storage : Array
@export var required_logs : int
@onready var label = $Label


@onready var animation_player = $AnimationPlayer


var ui : CanvasLayer

var player_is_in_range = false
var player_inventory_array

func _ready():
	if (!required_logs): #just in case i forgot to set requiered logs in inspector
		print("wagon required logs = 0")
	
	ui = get_tree().root.get_node("main/UI")
	update_label()

func update_label():
	label.text = "LOGS: " + str(wagon_storage.size()) + "/" + str(required_logs)

func _input(event):
	if player_is_in_range && event.is_action_pressed("use"):
		player_inventory_array = get_tree().root.get_node("main/Player/itemArea2D").inventory
		for item in player_inventory_array:
			player_inventory_array.erase(item)
			wagon_storage.push_front(item)
			ui.changeTxt(player_inventory_array)
			update_label()
			
			animation_player.play("deposit")
			
			if (wagon_storage.size() == required_logs): #WIN
				level_complete()
			break
			
func level_complete():
	levelManager.level_complete()

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		#animation_player.play("blink_and_size")
		player_is_in_range = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("player"):
		#animation_player.play("blinkAlpha")
		player_is_in_range = false
