extends CanvasLayer

@onready var inventory_amount_label = %score
var amount_of_items = 0

func changeTxt(list:Array):
	amount_of_items = str(list.size())
	inventory_amount_label.text = "Logs: " + amount_of_items
