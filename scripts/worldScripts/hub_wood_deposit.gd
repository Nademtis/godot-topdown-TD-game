extends Node2D

@onready var label: Label = $Control/MarginContainer/Label
@onready var area_2d: Area2D = $Area2D

var ui : CanvasLayer

var player_is_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()
	ui = get_tree().root.get_node("main/UI")
	print(ui)


func update_label():
	label.text = str(PlayerInventory.hub_storage.size())

func _input(event):
	var player_inventory = PlayerInventory.player_inventory
	var hub_storage = PlayerInventory.hub_storage
	
	if player_is_in_range && event.is_action_pressed("use"):
		for item in PlayerInventory.player_inventory:
			player_inventory.erase(item)
			hub_storage.push_front(item)
			
			#updateUI
			update_label()
			ui.player_inventory_ui.update_inventory_UI()
			audio.item_log_pickup()
			
			#animation_player.play("deposit")
			
			#print('wagon size: ' + str(wagon_storage.size()))
			break
	elif player_is_in_range && event.is_action_pressed("retract"):
		if player_inventory.size() < PlayerStats.player_inventory_size:
			for item in hub_storage:
				hub_storage.erase(item)
				player_inventory.push_front(item)
				
				update_label()
				#ui.player_inventory_ui.update_inventory_UI()
				ui.update_player_inventory_ui()
				audio.item_log_pickup()
				
				#animation_player.play("deposit")
				break

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		#animation_player.play("blink_and_size")
		player_is_in_range = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		#animation_player.play("blink_and_size")
		player_is_in_range = false
