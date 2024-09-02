extends Node

const LEVEL_PATH = "res://scenes/levels/level"  # Base path for levels
const LEVEL_EXTENSION = ".tscn"  # Scene file extension

var current_scene = null
var current_index : int = 0


func _ready():
	pass

# Call this function when a level is complete
func level_complete():
	var new_level_index = current_index +1
	var new_level_path = LEVEL_PATH + str(new_level_index) + LEVEL_EXTENSION

	if ResourceLoader.exists(new_level_path):
		var new_scene = ResourceLoader.load(new_level_path)
		if new_scene:
			call_deferred("_deferred_goto_scene", new_level_path)
		pass
	else:
		print_debug("No more levels - Game completed")
	pass

func _deferred_goto_scene(new_level_path):
	current_scene.free()  # It is now safe to remove the current scene.
	var s = ResourceLoader.load(new_level_path) # Load the new scene.
	current_scene = s.instantiate() # Instance the new scene.
	get_tree().root.add_child(current_scene) # Add it to the active scene, as child of root.
	get_tree().current_scene = current_scene

func set_current_level(level):
	current_scene = level
	var file_name = level.scene_file_path #level1.tscn
	var match = file_name.substr(5, file_name.length() - 10)
	current_index = match.to_int()
