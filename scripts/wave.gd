extends Resource

class_name Wave

@export var slime_amount : int
@export var bee_amount : int
@export var wave_duration : float

var total_amount_of_enemies : int
var spawn_rate : float


func _init(p_duration: float = 15, p_slime_amount: int = 1, p_bee_amount: int = 1):
	slime_amount = p_slime_amount
	bee_amount = p_bee_amount
	wave_duration = p_duration
	
	print(slime_amount) # prints 0 even when i have waves in the inspecter window array
	print(bee_amount)
	
	
	total_amount_of_enemies = slime_amount + bee_amount
	spawn_rate = wave_duration/total_amount_of_enemies

func get_random_enemy_path():
	pass
