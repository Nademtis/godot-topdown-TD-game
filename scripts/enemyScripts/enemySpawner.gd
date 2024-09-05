extends Node


@onready var path_2d : Path2D = $Path2D

@onready var wave_duration_timer: Timer = $Timer
@onready var enemy_spawn_rate_timer: Timer = $enemySpawnRateTimer

@onready var ui_wave_h_box : HBoxContainer = get_node("/root/main/UI").wave_uih_box
@onready var progress_dot : ColorRect = get_node("/root/main/UI").progress_dot
var scrollspeed : float = 0.12 #test

@export var waves : Array[Wave]

var current_wave_index : int = 0

func _process(delta: float) -> void:
	var oldPos = ui_wave_h_box.position
	ui_wave_h_box.set_position(Vector2(oldPos.x - scrollspeed, oldPos.y))
	pass

func _ready() -> void:
	if waves.is_empty():
		print_debug('no waves in this level')
	else:
		enemy_spawn_rate_timer.timeout.connect(spawn_enemy)
		call_deferred("create_wave_indicator_ui")
		start_wave()
		
func start_wave():
	print('wave started')
	
	if (waves.size() >= current_wave_index+1):
		var wave : Wave = waves[current_wave_index]
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
	

func create_wave_indicator_ui():
	# Clear existing children in the HBoxContainer
	for child in ui_wave_h_box.get_children():
		child.queue_free()

	# Calculate the total wave duration
	var total_duration: float = 0
	for wave : Wave in waves:
		total_duration += wave.wave_duration
		
	# Create ColorRects based on wave durations
	for wave in waves:
		wave.init_wave()
		var color_rect : ColorRect = ColorRect.new()
		# Set the color based on wave difficulty (Example)
		if wave.total_amount_of_enemies == 0:
			color_rect.color = Color(0, 1, 0)  # Green
		elif wave.total_amount_of_enemies > 10:  # Example condition
			color_rect.color = Color(1, 0, 0)  # Red
		else:
			color_rect.color = Color(1, 1, 0)  # Yellow

		# Calculate width proportional to wave duration
		var proportion: float = wave.wave_duration / total_duration
		var container_width: float = ui_wave_h_box.size.x
		color_rect.set_custom_minimum_size(Vector2(container_width * proportion, 20))
		
		# Add the ColorRect to the HBoxContainer
		ui_wave_h_box.add_child(color_rect)
