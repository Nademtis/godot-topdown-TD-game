extends Node2D

class_name BuildableObject

var player_is_in_range = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var temp_texture: Texture2D #for the texture
var temp_optional_deposit_coll : CollisionShape2D #for big objects like bridge this is sent as optional parameter

var hub_upgrade : HubProgression.HUB_UPGRADE
var total_build_cost : int

func _ready() -> void:
	sprite_2d.texture = temp_texture
	var original_build_cost_length = HubProgression.build_recipe_original_price[hub_upgrade]
	var deposited_amount = original_build_cost_length - total_build_cost
	label.text = str(deposited_amount) + '/' + str(original_build_cost_length)  # Display build status
	if temp_optional_deposit_coll != null:
		temp_optional_deposit_coll.reparent(area_2d)
		pass

func initialize(p_hub_upgrade: HubProgression.HUB_UPGRADE, p_texture : Texture2D, p_collision_shape: CollisionShape2D = null) -> void:
	hub_upgrade = p_hub_upgrade
	temp_texture = p_texture #todo find better solutiona
	total_build_cost = HubProgression.build_recipe_dic[hub_upgrade].size()
	
	if p_collision_shape != null: #optional shape for wierd objects like bridge
		temp_optional_deposit_coll = p_collision_shape

func _input(event):
	var item_cost_array = HubProgression.build_recipe_dic[hub_upgrade]
	if player_is_in_range && event.is_action_pressed("use"):
		for item : ItemResource in PlayerInventory.hub_storage:
			if item_cost_array.has(item):
				PlayerInventory.hub_storage.erase(item)
				item_cost_array.erase(item)
				
				#call main and update hub storage log amount
				var level_node : Level = get_parent().get_parent()
				level_node.update_amount_of_hub_wood()
				
				check_build_status()
				
				#ui and sfx
				#ui.player_inventory_ui.update_inventory_UI()
				audio.hammer()
				break

func check_build_status():
	var original_price: int = HubProgression.build_recipe_original_price[hub_upgrade]
	var price_left : int = HubProgression.build_recipe_dic[hub_upgrade].size()
	label.text = str(original_price - price_left) + '/' + str(original_price)  # Display build status
	
	if HubProgression.build_recipe_dic[hub_upgrade].size() <= 0:
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
