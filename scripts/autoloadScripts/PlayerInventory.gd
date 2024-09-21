extends Node

var player_inventory : Array[ItemResource] = []
var wagon_storage : Array[ItemResource] = []
var hub_storage : Array[ItemResource] = []
var coin_amount : int

func _ready() -> void:
	debug_start_with_logs_hub(50)
	#debug_start_with_coins(50)
	pass

func add_coin():
	coin_amount += 1


func debug_start_with_logs_hub (log_amount: int):
	var log_resource = ItemSpawner.LOG_RESOURCE # Assuming LOG_RESOURCE is defined in ItemSpawner
	for i in range(log_amount):
		hub_storage.append(log_resource)
	print('Initialized hub storage with ' + str(log_amount) + ' logs')
		
func debug_start_with_coins (coin_amount_meme: int):
	coin_amount = coin_amount_meme
	print('Initialized coins amount' + str(coin_amount))
	
func return_to_hub():
	#put stuff from wagon into hub_storage
	print('you return home with: ' + str(wagon_storage.size()) + ' logs')
	hub_storage.append_array(wagon_storage)
	wagon_storage.clear()
	player_inventory.clear()
	
