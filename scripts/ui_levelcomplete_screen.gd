extends Control

class_name UiLevelCompleteScreen
@onready var amount_of_wood_gathered_label: Label = $frame/MarginContainer/Control/gatheredItemsFrame/MarginContainer/HBoxContainer/Label
var amount_of_wood_gathered : int = 0

func _on_go_home_button_button_down() -> void:
	levelManager.level_complete()

func set_gathered_amount() -> void:
	amount_of_wood_gathered += PlayerInventory.player_inventory.size()
	amount_of_wood_gathered += PlayerInventory.wagon_storage.size()
	amount_of_wood_gathered_label.text = str(amount_of_wood_gathered)
