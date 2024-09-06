extends Node

var player_inventory : Array[ItemResource] = []
var wagon_storage : Array[ItemResource] = []
var coin_amount : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start_with_logs(2)
	pass # Replace with function body.

func add_coin():
	coin_amount += 1

func start_with_logs (log_amount: int):
	for i in log_amount:
		#var item : Item = 
		player_inventory.push_back("Log")
