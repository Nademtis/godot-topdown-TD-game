extends Node2D

class_name BuildableObject

var player_is_in_range = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D

var temp_texture


var hub_upgrade : HubProgression.HUB_UPGRADE
var item_cost_array : Array[ItemResource]
var build_cost : int

func _ready() -> void:
	sprite_2d.texture = temp_texture
	label.text = str(0) + '/' + str(build_cost)  # Display build status

func initialize(p_hub_upgrade: HubProgression.HUB_UPGRADE, p_item_cost_array: Array[ItemResource], p_texture : Texture2D) -> void:
	hub_upgrade = p_hub_upgrade
	item_cost_array = p_item_cost_array
	temp_texture = p_texture #todo find better solution
	build_cost = p_item_cost_array.size()

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
		HubProgression.hub_upgrade_finished(hub_upgrade)
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		animation_player.play("blink_and_size")
		player_is_in_range = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		animation_player.play("blink_alpha")
		player_is_in_range = false
