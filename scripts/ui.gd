extends CanvasLayer

class_name MainUI

@onready var inventory_amount_label = %score
var amount_of_items = 0

@onready var heart_1 = $Control/MarginContainer/VBoxContainer/Control/heart1
@onready var heart_2 = $Control/MarginContainer/VBoxContainer/Control/heart2
@onready var heart_3 = $Control/MarginContainer/VBoxContainer/Control/heart3

@onready var wave_uih_box: HBoxContainer = %waveUIHBox
@onready var progress_dot: ColorRect = %progressDot

@onready var player_inventory_ui: Control = %playerInventoryUI

@onready var ui_level_complete_warning: Control = $Control/MarginContainer/UiLevelCompleteWarning
@onready var level_complete_countdown_label : Label

func _ready():
	self.visible = true
	update_coins_ui()
	ui_level_complete_warning.visible = false
	
	level_complete_countdown_label = ui_level_complete_warning.get_node("countdown")

func show_level_complete_ui(amount_of_seconds_left: float):
	ui_level_complete_warning.visible = true
	update_level_complete_label(amount_of_seconds_left)

func update_level_complete_label(amount_of_seconds_left: float):
	level_complete_countdown_label.text = str(int(amount_of_seconds_left))
	level_complete_countdown_label.scale = Vector2(1, 1)
	
	# Create a new tween and animate the scale
	var tween = get_tree().create_tween()
	# Tween the scale to 1.2 (grow the label)
	tween.tween_property(level_complete_countdown_label, "scale", Vector2(1.2, 1.2), 0.3)
	# Add a follow-up tween to shrink it back to 1.0 after the initial tween completes
	tween.tween_property(level_complete_countdown_label, "scale", Vector2(1, 1), 0.3).set_delay(0.3)

func update_coins_ui():
	var amount_of_coins = PlayerInventory.coin_amount
	inventory_amount_label.text = "Coins: " + str(amount_of_coins)
	
func update_ui_hp(new_health:int):
	match new_health:
		3:
			heart_1.visible = true
			heart_2.visible = true
			heart_3.visible = true
		2:
			heart_1.visible = true
			heart_2.visible = true
			heart_3.visible = false
		1:
			heart_1.visible = true
			heart_2.visible = false
			heart_3.visible = false
		0:
			heart_1.visible = false
			heart_2.visible = false
			heart_3.visible = false
			
