extends Node2D

var wagon_storage : Array [ItemResource] = PlayerInventory.wagon_storage
@export var required_logs : int
@onready var label = $Label


@onready var animation_player = $AnimationPlayer

var ui : CanvasLayer

var player_is_in_range = false
var player_inventory : Array[ItemResource] = PlayerInventory.player_inventory

func _ready():
	if (!required_logs): #just in case i forgot to set requiered logs in inspector
		print_debug("wagon required logs = 0")
	
	ui = get_tree().root.get_node("main/UI")
	update_label()

func update_label():
	if required_logs != 0:
		#for levels where there is required amount
		label.text = str(wagon_storage.size()) + "/" + str(required_logs)
	else:
		#for levels where levels ends when no more waves
		label.text = str(wagon_storage.size())

func _input(event):
	if player_is_in_range && event.is_action_pressed("use"):
		for item in player_inventory:
			player_inventory.erase(item)
			wagon_storage.push_front(item)
			
			#updateUI
			update_label()
			ui.player_inventory_ui.update_inventory_UI()
			audio.item_log_pickup()
			
			animation_player.play("deposit")
			
			#print('wagon size: ' + str(wagon_storage.size()))
			
			if required_logs!= 0 && wagon_storage.size() >= required_logs: #WIN
				level_complete() #old 
			break
	elif player_is_in_range && event.is_action_pressed("retract"):
		if player_inventory.size() < PlayerStats.player_inventory_size:
			for item in wagon_storage:
				wagon_storage.erase(item)
				player_inventory.push_front(item)
				
				update_label()
				ui.player_inventory_ui.update_inventory_UI()
				audio.item_log_pickup()
				
				animation_player.play("deposit")
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
