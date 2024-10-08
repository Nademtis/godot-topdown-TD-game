extends Node2D

class_name Wagon

var wagon_storage : Array [ItemResource] = PlayerInventory.wagon_storage
@export var required_logs : int
@onready var label = $Label


@onready var animation_player = $AnimationPlayer
@onready var use_button_eui: UseButton = $UseButtonEUI
@onready var use_button_rui: UseButton = $UseButtonRUI

var ui : CanvasLayer

var player_is_in_range = false
var player_inventory : Array[ItemResource] = PlayerInventory.player_inventory

func _ready():
	if (!required_logs): #just in case i forgot to set requiered logs in inspector
		pass
		print_debug("wagon required logs = 0")
	
	#ui = get_tree().get_first_node_in_group("mainUI")  # Use root to access globally unique nodes
	#print_debug(ui)
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
			Events.emit_signal("player_inventory_changed")
			
			audio.item_log_pickup()
			use_button_eui.use_button()
			animation_player.play("deposit")
			
			#print('wagon size: ' + str(wagon_storage.size()))
			
			if required_logs!= 0 && wagon_storage.size() >= required_logs: #WIN
				level_complete() #old 
			return
		use_button_eui.use_button_fail()
	elif player_is_in_range && event.is_action_pressed("retract"):
		if player_inventory.size() < PlayerStats.player_inventory_size:
			for item in wagon_storage:
				wagon_storage.erase(item)
				player_inventory.push_front(item)
				
				update_label()
				Events.emit_signal("player_inventory_changed")
				audio.item_log_pickup()
				use_button_rui.use_button()
				
				
				animation_player.play("deposit")
				return
			use_button_rui.use_button_fail()
		
func level_complete():
	levelManager.level_complete()

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		use_button_eui.show_button()
		use_button_rui.show_button()
		#animation_player.play("blink_and_size")
		player_is_in_range = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("player"):
		use_button_eui.hide_button()
		use_button_rui.hide_button()
		
		#animation_player.play("blinkAlpha")
		player_is_in_range = false
