extends Node

const LEVEL_PATH = "res://scenes/gameplay/levels/level"  # Base path for levels
const LEVEL_EXTENSION = ".tscn"  # Scene file extension

var current_scene = null
var current_index : int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer #used for scene transition

func _ready():
	pass

# Call this function when a level is complete
func level_complete():
	animation_player.play('fade_in')
	var new_level_index = current_index + 1
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
	PlayerInventory.player_inventory.clear()
	PlayerInventory.wagon_storage.clear()
	
	
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

func get_current_level_wavelist():
	#var wave_break_small : Wave = Wave.new(0,0,5)
	#var wave_break_medium : Wave = Wave.new(0,0,10)
	#var wave_break_large : Wave = Wave.new(0,0,15)
	
	var breaks = {
		"small": Wave.new(0,0,5),
		"medium":Wave.new(0,0,10),
		"large": Wave.new(0,0,15)
	}
	
	var wavelist : Array[Wave] = []
	print_debug('fetches waveList with index: ' + str(current_index))
	match current_index:
		#slime, bee, duration
		1:
			var wave1 : Wave = breaks.large
			var wave2 : Wave = Wave.new(5,5,20)
			var wave3 : Wave = breaks.small
			var wave4 : Wave = Wave.new(10,10,20)
			var wave5 : Wave = breaks.small
			var wave6 : Wave = Wave.new(15,15,20)
			wavelist = [wave1, wave2, wave3, wave4, wave5, wave6]
		2:
			var wave1 : Wave = breaks.medium
			var wave2 : Wave = Wave.new(10,10,20)
			var wave3 : Wave = breaks.small
			var wave4 : Wave = Wave.new(15,15,10)
			var wave5 : Wave = Wave.new(20,20,15)
			var wave6 : Wave = Wave.new(20,20,15)
			wavelist = [wave1, wave2, wave3, wave4, wave5, wave6]
		3:
			var wave1 : Wave = breaks.small
			var wave2 : Wave = Wave.new(10,10,15)
			var wave3 : Wave = breaks.small
			var wave4 : Wave = Wave.new(15,15,10)
			var wave5 : Wave = Wave.new(20,20,15)
			var wave6 : Wave = Wave.new(20,20,15)
			wavelist = [wave1, wave2, wave3, wave4, wave5, wave6]
	
	return wavelist
	#return level0_wavelist
