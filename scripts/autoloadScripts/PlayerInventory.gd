extends Node

var player_inventory : Array[String] = []
var wagon_storage : Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_with_logs(10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func start_with_logs (log_amout: int):
	for i in log_amout:
		player_inventory.push_back("Log")
