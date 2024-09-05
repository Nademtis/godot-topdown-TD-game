extends CanvasLayer

@onready var inventory_amount_label = %score
var amount_of_items = 0

@onready var heart_1 = $Control/MarginContainer/VBoxContainer/Control/heart1
@onready var heart_2 = $Control/MarginContainer/VBoxContainer/Control/heart2
@onready var heart_3 = $Control/MarginContainer/VBoxContainer/Control/heart3

@onready var wave_uih_box: HBoxContainer = %waveUIHBox
@onready var progress_dot: ColorRect = %progressDot

func _ready():
	self.visible = true

func changeTxt(list:Array):
	amount_of_items = str(list.size())
	inventory_amount_label.text = "Logs: " + amount_of_items
	
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
			
