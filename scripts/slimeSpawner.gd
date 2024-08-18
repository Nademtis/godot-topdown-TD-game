extends Node

@onready var slimePath = preload("res://scenes/slime_mob.tscn")
@onready var path_2d = $Path2D

func _on_timer_timeout():
	var tempPath = slimePath.instantiate()
	path_2d.add_child(tempPath)
