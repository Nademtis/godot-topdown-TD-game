extends Node


@onready var path_2d : Path2D = $Path2D

@onready var wave_duration_timer: Timer = $Timer
@onready var enemy_spawn_rate_timer: Timer = $enemySpawnRateTimer

@export var waves : Array[Wave]

var current_wave_index : int = 0
enum WaveStatus {}


func _ready() -> void:
	if waves.is_empty():
		print_debug('no waves in this level')
	else:
		enemy_spawn_rate_timer.timeout.connect(spawn_enemy)
		start_wave()
		
func start_wave():
	print('wave started')
	
	if (waves.size() >= current_wave_index+1):
		var wave : Wave = waves[current_wave_index]
		wave.init_wave()
		wave_duration_timer.wait_time = wave.wave_duration + 1 #plus 1 second to add a breathing room
		wave_duration_timer.start()
		
		if wave.total_amount_of_enemies > 0: #when there are enemies in wave
			enemy_spawn_rate_timer.wait_time = wave.spawn_rate
			enemy_spawn_rate_timer.start()
		else:
			print('no enemies in this wave')
	else:
		print("no more levels")
		
func next_wave():
	enemy_spawn_rate_timer.stop()
	if waves[current_wave_index].mobs_left_in_wave > 0:
		print("whoops waiting for next wave, everything havent spawned")
		print("mobs left based on spawner " + str(waves[current_wave_index].mobs_left_in_wave))
		next_wave()
	else:
		print("swapping wave")
		current_wave_index += 1
		start_wave()

func _on_timer_timeout():
	next_wave()


func spawn_enemy():
	var mobPath: PackedScene = waves[current_wave_index].get_random_enemy_path()
	var mob: Node2D = mobPath.instantiate()
	var pathFollow2D : PathFollow2D = PathFollow2D.new()
	pathFollow2D.loop = false
	pathFollow2D.rotates = false
	
	path_2d.add_child(pathFollow2D)
	pathFollow2D.add_child(mob)
	
