extends Node

@onready var slimePath = preload("res://scenes/slime_mob_with_path.tscn")

func _on_timer_timeout():
	var tempPath = slimePath.instantiate()
	add_child(tempPath)
