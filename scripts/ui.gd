extends CanvasLayer

@onready var inventory_amount_label = %score
var amount_of_items = 0

@onready var heart_1 = $Control/MarginContainer/VBoxContainer/Control/heart1
@onready var heart_2 = $Control/MarginContainer/VBoxContainer/Control/heart2
@onready var heart_3 = $Control/MarginContainer/VBoxContainer/Control/heart3

@onready var wave_uih_box: HBoxContainer = %waveUIHBox
@onready var progress_dot: ColorRect = %progressDot

@onready var player_inventory_ui: Control = %playerInventoryUI

func _ready():
	self.visible = true
	update_coins_ui()

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
			
