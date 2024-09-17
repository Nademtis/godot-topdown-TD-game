extends Resource

class_name Wave

var SLIME : PackedScene = preload("res://scenes/slime.tscn")
var BEE : PackedScene = preload("res://scenes/bee.tscn")

@export var slime_amount : int
@export var bee_amount : int
@export var wave_duration : float

var total_amount_of_enemies : int
var spawn_rate : float
var mobs_left_in_wave : int 

func _init(p_slime_amount: int, p_bee_amount: int, p_wave_duration: float):
	slime_amount = p_slime_amount
	bee_amount = p_bee_amount
	wave_duration = p_wave_duration
	init_wave()

func init_wave():
	calculate_mob_numbers()
	total_amount_of_enemies = slime_amount + bee_amount
	if total_amount_of_enemies > 0:
		spawn_rate = wave_duration / total_amount_of_enemies
	else:
		spawn_rate = 0

func calculate_mob_numbers():
	mobs_left_in_wave = slime_amount + bee_amount
	print("mobs left " + str(mobs_left_in_wave))

func get_random_enemy_path() -> PackedScene:
	var random = randf()
	
	if random > 0.5 && slime_amount > 0:
		slime_amount -= 1
		calculate_mob_numbers()
		return SLIME
	else:
		bee_amount -= 1
		calculate_mob_numbers()
		return BEE
