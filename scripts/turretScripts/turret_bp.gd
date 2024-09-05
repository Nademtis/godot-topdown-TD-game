extends Node2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready  var turret_path = preload("res://scenes/turretScenes/turret.tscn")
@onready var label = $Label

var ui : CanvasLayer

var player_is_in_range = false
@export var item_cost_array : Array[String]
var player_inventory : Array[ItemResource] = PlayerInventory.player_inventory

func _ready():
	item_cost_array = item_cost_array.duplicate()
	ui = get_tree().root.get_node("main/UI")
	#this above makes sure every BP has its own recipe. - not shared amongst instances
	

func check_build_status():
	label.text = "Put Logs: " + str(item_cost_array.size())
	if item_cost_array.size() <= 0:
		var turret = turret_path.instantiate()
		var turretContainer = get_tree().root.get_node("main").get_node("TurretContainer")
		turret.global_position = global_position
		turretContainer.add_child(turret)
		queue_free()

func _input(event):
	if player_is_in_range && event.is_action_pressed("use"):
		for item in player_inventory:
			if item_cost_array.has(item):
				player_inventory.erase(item)
				item_cost_array.erase(item)
				check_build_status()
				ui.changeTxt(player_inventory)
				break

func _on_area_2d_area_entered(area):
	#label.visible = true
	if area.is_in_group("player"):
		animation_player.play("blink_and_size")
		player_is_in_range = true
	

func _on_area_2d_area_exited(area):
	#label.visible = false
	if area.is_in_group("player"):
		animation_player.play("blinkAlpha")
		player_is_in_range = false
