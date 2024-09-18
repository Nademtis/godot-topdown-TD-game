extends Node

var player_inventory : Array[ItemResource] = []
var wagon_storage : Array[ItemResource] = []
var hub_storage : Array[ItemResource] = []
var coin_amount : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_with_logs_hub(5)
	start_with_coins(50)
	pass # Replace with function body.

func add_coin():
	coin_amount += 1
	print('Initialized coins amount' + str(coin_amount))

func start_with_logs_hub (log_amount: int):
	var log_resource = ItemSpawner.LOG_RESOURCE # Assuming LOG_RESOURCE is defined in ItemSpawner
	for i in range(log_amount):
		hub_storage.append(log_resource)
	print('Initialized hub storage with ' + str(log_amount) + ' logs')
		
func start_with_coins (coin_amount_meme: int):
	coin_amount = coin_amount_meme

func return_to_hub():
	#put stuff from wagon into hub_storage
	print('you return home with: ' + str(wagon_storage.size()) + ' logs')
	hub_storage.append_array(wagon_storage)
	wagon_storage.clear()
	player_inventory.clear()
	
