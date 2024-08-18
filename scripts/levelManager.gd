extends Node

const LEVEL_PATH = "res://scenes/levels/level"  # Base path for levels
const LEVEL_EXTENSION = ".tscn"  # Scene file extension

var current_scene = null

func _ready():
	print("Hello from LevelManager")

# Call this function when a level is complete
func level_complete():
	pass
	# Access the current scene from the scene tree
	# TODO swap levels
