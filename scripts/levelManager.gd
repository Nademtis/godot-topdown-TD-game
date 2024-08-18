extends Node

const LEVEL_PATH = "res://scenes/levels/level"  # Base path for levels
const LEVEL_EXTENSION = ".tscn"  # Scene file extension

var current_scene = null

func _ready():
	pass

# Call this function when a level is complete
func level_complete():
	pass
	# Access the current scene from the scene tree
	# TODO swap levels

func set_current_level(level):
	current_scene = level #return res://scenes/levels/level1.tscn
	#var current_index = leve
