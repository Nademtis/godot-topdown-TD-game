extends Node2D

@onready var label: Label = $Control/MarginContainer/Label
@onready var area_2d: Area2D = $Area2D

@onready var use_button_eui: UseButton = $UseButtonEUI
@onready var use_button_rui: UseButton = $UseButtonRUI

var player_is_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()


func update_label():
	label.text = str(PlayerInventory.hub_storage.size())

func _input(event):
	var player_inventory = PlayerInventory.player_inventory
	var hub_storage = PlayerInventory.hub_storage
	
	if player_is_in_range && event.is_action_pressed("use"):
		for item in PlayerInventory.player_inventory:
			player_inventory.erase(item)
			hub_storage.push_front(item)
			
			#UI
			update_label()
			Events.emit_signal("player_inventory_changed")
			get_parent().update_amount_of_hub_wood()
			
			use_button_eui.use_button()
			audio.item_log_pickup()
			#animation_player.play("deposit")
			return
		use_button_eui.use_button_fail()
		
	elif player_is_in_range && event.is_action_pressed("retract"):
		if player_inventory.size() < PlayerStats.player_inventory_size:
			for item in hub_storage:
				hub_storage.erase(item)
				player_inventory.push_front(item)
				
				#UI
				update_label()
				Events.emit_signal("player_inventory_changed")
				get_parent().update_amount_of_hub_wood()
				use_button_rui.use_button()
				
				audio.item_log_pickup()
				
				#animation_player.play("deposit")
				return
			use_button_rui.use_button_fail()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		use_button_eui.show_button()
		use_button_rui.show_button()
		#animation_player.play("blink_and_size")
		player_is_in_range = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		use_button_eui.hide_button()
		use_button_rui.hide_button()
		#animation_player.play("blink_and_size")
		player_is_in_range = false
