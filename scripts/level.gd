extends Node

@export var hp : int = 3
@export var current_hp : int = 3
@onready var ui = $UI

func _ready():
	levelManager.set_current_level(self)

func take_damage():
	current_hp -= 1
	if current_hp <= 0:
		die()
	ui.update_ui_hp(current_hp)
	
func die():
	print("Gameover")
	print_debug("die() is turned off")
	#get_tree().reload_current_scene()
