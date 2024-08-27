extends Node

@onready var SLIME = preload("res://scenes/slime.tscn")
@onready var BEE = preload("res://scenes/bee.tscn")
@onready var path_2d : Path2D = $Path2D
@onready var spawn_rate_timer: Timer = $Timer


@onready var meme_timer: Timer = $memeTimer # todo kill after

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


func _on_meme_timer_timeout() -> void:
	print_debug('more enemies spawning')
	spawn_rate_timer.wait_time -= 0.05
	if spawn_rate_timer.wait_time <= 0.1:
			spawn_rate_timer.wait_time = 0.1
