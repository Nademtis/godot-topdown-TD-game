extends Resource

class_name Wave

var SLIME : PackedScene = preload("res://scenes/slime.tscn")
var BEE : PackedScene = preload("res://scenes/bee.tscn")
var RAT : PackedScene = preload("res://scenes/rat.tscn")
var OGRE : PackedScene = preload("res://scenes/ogre.tscn")

@export var slime_amount : int
@export var bee_amount : int
@export var rat_amount : int
@export var ogre_amount : int
enum ENEMY {SLIME, BEE, RAT, OGRE}
var enemyList : Array[ENEMY] = []

@export var wave_duration : float

var total_amount_of_enemies : int
var spawn_rate : float
var mobs_left_in_wave : int 

func _init(p_slime_amount: int, p_bee_amount: int, p_rat_amount:int, p_ogre_amount:int, p_wave_duration: float):
	slime_amount = p_slime_amount
	bee_amount = p_bee_amount
	rat_amount = p_rat_amount
	ogre_amount = p_ogre_amount
	
	enemyList.clear()
	enemyList.resize(slime_amount + bee_amount + rat_amount + ogre_amount)
	
	for i in range(slime_amount):
		enemyList.push_back(ENEMY.SLIME)
	for i in range(bee_amount):
		enemyList.push_back(ENEMY.BEE)
	for i in range(rat_amount):
		enemyList.push_back(ENEMY.RAT)
	for i in range(ogre_amount):
		enemyList.push_back(ENEMY.OGRE)
	
	wave_duration = p_wave_duration
	init_wave()

func init_wave():
	calculate_mob_numbers()
	total_amount_of_enemies = slime_amount + bee_amount + rat_amount + ogre_amount
	if total_amount_of_enemies > 0:
		spawn_rate = wave_duration / total_amount_of_enemies
	else:
		spawn_rate = 0

func calculate_mob_numbers():
	mobs_left_in_wave = slime_amount + bee_amount + rat_amount + ogre_amount
	#print("mobs left " + str(mobs_left_in_wave))

func get_random_enemy_path() -> PackedScene:
	if enemyList.size() > 0:
		var random_index = randi_range(0, enemyList.size() - 1)
		var enemy = enemyList[random_index]
		enemyList.remove_at(random_index)
		match enemy:
			ENEMY.SLIME:
				return SLIME
			ENEMY.BEE:
				return BEE
			ENEMY.RAT:
				return RAT
			ENEMY.OGRE:
				return OGRE
			_:
				return SLIME
	else:
		push_warning("SLIME RETURNED HERE, should not happen")
		return SLIME
