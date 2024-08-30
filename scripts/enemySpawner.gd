extends Node

@onready var SLIME = preload("res://scenes/slime.tscn")
@onready var BEE = preload("res://scenes/bee.tscn")
@onready var path_2d : Path2D = $Path2D

@onready var wave_duration_timer: Timer = $Timer

@export var waves : Array[Wave]

var current_wave_index : int = 0
enum WaveStatus {}
var spawn_rate_timer : Timer = Timer.new()

func _ready() -> void:
	if waves.is_empty():
		print_debug('no waves in this level')
	else:
		start_wave()

func start_wave():
	print('wave started')
	var wave : Wave = waves[current_wave_index]
	wave_duration_timer.wait_time = wave.wave_duration
	wave_duration_timer.start()
	spawn_rate_timer.wait_time = wave.spawn_rate
	print(spawn_rate_timer.wait_time)
	spawn_rate_timer.timeout.connect(spawn_enemy)
	spawn_rate_timer.autostart = true

func _on_timer_timeout():
	var random : float = randf()
	var enemyPath
	if random > 0.5:
		enemyPath = SLIME.instantiate()
	else:
		enemyPath = BEE.instantiate()
		
	var pathFollow2D : PathFollow2D = PathFollow2D.new()
	pathFollow2D.loop = false
	pathFollow2D.rotates = false
	
	path_2d.add_child(pathFollow2D)
	pathFollow2D.add_child(enemyPath)

func spawn_enemy(mob: String):
	print(mob)
	print('bing')
	pass
	
