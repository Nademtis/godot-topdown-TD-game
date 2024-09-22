extends Node


@onready var path_2d_1 : Path2D = $Path2D1
@onready var path_2d_2: Path2D = $Path2D2


@onready var wave_duration_timer: Timer = $Timer
@onready var enemy_spawn_rate_timer: Timer = $enemySpawnRateTimer

@onready var ui_wave_h_box : HBoxContainer = get_node("/root/main/UI").wave_uih_box
#@onready var progress_dot : ColorRect = get_node("/root/main/UI").progress_dot # not used
@onready var ui : MainUI = get_node("/root/main/UI")

var level_complete_timer : Timer = Timer.new()
var amount_of_time_before_hub : float =  10

var scrollspeed : float = 0.12 #test for wave ui - not used currently

var waves : Array[Wave]

var cave_has_opened = false
var cave_has_closed = false
@onready var cave: AnimatedSprite2D = $Cave
@onready var player: Player = $"../Player"


var current_wave_index : int = 0

func _process(_delta: float) -> void:
	var oldPos = ui_wave_h_box.position
	ui_wave_h_box.set_position(Vector2(oldPos.x - scrollspeed, oldPos.y))
	pass

func _ready() -> void:
	levelManager.set_current_level(get_parent())
	waves.clear()
	waves = levelManager.get_current_level_wavelist()
	#var totalMobAmount = 0
	#for wave in waves:
	#	totalMobAmount += wave.mobs_left_in_wave
		
	#print('total Mobs in this ' + str(totalMobAmount))
	#print('this level has: ' + str(waves.size()) + ' waves')
	
	if waves.is_empty():
		pass
		#print_debug('no waves in this level')
	else:
		enemy_spawn_rate_timer.timeout.connect(spawn_enemy)
		call_deferred("create_wave_indicator_ui")
		start_wave()
		
func start_wave():
	#print('wave started')
	if (waves.size() >= current_wave_index + 1):
		var wave : Wave = waves[current_wave_index]
		wave.init_wave()
		
		#check has_opened 
		if  wave.total_amount_of_enemies > 0 && !cave_has_opened:
			open_cave()
		
		wave_duration_timer.wait_time = wave.wave_duration + 1 #plus 1 second to add a breathing room
		wave_duration_timer.start()
		
		if wave.total_amount_of_enemies > 0: #when there are enemies in wave
			enemy_spawn_rate_timer.wait_time = wave.spawn_rate
			enemy_spawn_rate_timer.start()
		else:
			#break wave
			pass
	else:
		close_cave()
		level_complete()
		
func next_wave():
	enemy_spawn_rate_timer.stop()
	if waves[current_wave_index].mobs_left_in_wave > 0:
		next_wave()
	else:
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
	
	var ranf = randf()
	if ranf > 0.5:
		path_2d_1.add_child(pathFollow2D)
	else:
		path_2d_2.add_child(pathFollow2D)
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

func level_complete():
	var amount_of_enemies_left : int = path_2d_1.get_children().size() + path_2d_2.get_children().size()

	if amount_of_enemies_left > 0:
		print_debug('waiting since: ' + str(amount_of_enemies_left))
		await get_tree().create_timer(1.0).timeout
		level_complete()
	else:
		print_debug('continuing since: ' + str(amount_of_enemies_left))
		ui.show_level_complete_ui(amount_of_time_before_hub)
		level_complete_timer.wait_time = 1
		add_child(level_complete_timer)
		level_complete_timer.start()
		start_level_complete_countdown()

func start_level_complete_countdown():
	if amount_of_time_before_hub > 0:
		# Update the UI label
		ui.update_level_complete_label(amount_of_time_before_hub)
		amount_of_time_before_hub -= 1.0
		await level_complete_timer.timeout
		start_level_complete_countdown()
	else:
		player.cutscene_started(false)
		ui.display_level_complete_screen()

func open_cave():
	cave_has_opened = true
	audio.cave_moving()
	
	player.cutscene_started(true)
	player.camera.global_position = cave.global_position
	cave.play("cave_opening")
	await get_tree().create_timer(2.0).timeout
	player.cutscene_ended()
	
func close_cave():
	audio.cave_moving()
	player.apply_shake()
	cave.play("cave_closing")
	cave_has_closed = true
	print('close cave')
