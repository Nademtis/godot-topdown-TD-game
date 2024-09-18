extends Node2D

class_name BuildableObject

var player_is_in_range = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label


var item_cost_array : Array[ItemResource]
var build_cost

func _init() -> void:
	pass

func _input(event):
	if player_is_in_range && event.is_action_pressed("use"):
		for item : ItemResource in PlayerInventory.hub_storage:
			if item_cost_array.has(item):
				PlayerInventory.hub_storage.erase(item)
				item_cost_array.erase(item)
				check_build_status()
				
				#ui and sfx
				#ui.player_inventory_ui.update_inventory_UI()
				audio.hammer()
				
				break

func check_build_status():
	var collected_items = build_cost - item_cost_array.size()
	label.text = str(collected_items) + '/' + str(build_cost)  # Display build status
	if item_cost_array.size() <= 0:
		#var turret = turret_path.instantiate()
		#var turretContainer = get_tree().root.get_node("main").get_node("TurretContainer")
		#turret.global_position = global_position
		#turretContainer.add_child(turret)
		#TODO inform hub progression that object has been build
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		animation_player.play("blink_and_size")
		player_is_in_range = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		animation_player.play("blink_alpha")
		player_is_in_range = false
