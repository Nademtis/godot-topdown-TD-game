extends Node

@export var hp : int = 3
@export var current_hp : int = 3
@onready var ui : CanvasLayer = $UI

func init():
	pass
	#levelManager.set_current_level(self)

func _ready():
	#levelManager.set_current_level(self)
	pass

func take_damage():
	current_hp -= 1
	if current_hp <= 0:
		die()
	ui.update_ui_hp(current_hp)
	
func die():
	print("Gameover")
	print_debug("die() is turned off")
	get_tree().reload_current_scene()
