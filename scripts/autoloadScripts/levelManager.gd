extends Node

const LEVEL_PATH = "res://scenes/gameplay/levels/level"  # Base path for levels
const LEVEL_EXTENSION = ".tscn"  # Scene file extension

const HUB = "res://scenes/gameplay/hub.tscn"

var current_scene = null
var current_index : int = 0
var new_level_path: String
@onready var animation_player: AnimationPlayer = $AnimationPlayer #used for scene transition

func _ready():
	pass

# Call this function when a level is complete
func level_complete():
	PlayerInventory.return_to_hub()
	animation_player.play('fade_out')
	var new_level_index = current_index + 1
	new_level_path = LEVEL_PATH + str(new_level_index) + LEVEL_EXTENSION
	
	_deferred_goto_scene(HUB)


func start_next_level():
	if ResourceLoader.exists(new_level_path):
		var new_scene = ResourceLoader.load(new_level_path)
		if new_scene:
			call_deferred("_deferred_goto_scene", new_level_path)
		pass
	else:
		print_debug("No more levels - Game completed")
	pass	

func _deferred_goto_scene(path):
	if current_scene:
		current_scene.queue_free()  # Use queue_free() instead of free() for safer removal
	var s = ResourceLoader.load(path)
	if s == null:
		print_debug("Failed to load scene at: " + path)
		return
	current_scene = s.instantiate()
	if current_scene:
		get_tree().root.add_child(current_scene)
		get_tree().current_scene = current_scene
		animation_player.play('fade_in')

func set_current_level(level):
	current_scene = level
	var file_name = level.scene_file_path #level1.tscn
	var match = file_name.substr(5, file_name.length() - 10)
	current_index = match.to_int()

func get_current_level_wavelist():
	var breaks = {
		"small": Wave.new(0,0,5),
		"medium":Wave.new(0,0,10),
		"large": Wave.new(0,0,15)
	}
	
	var wavelist : Array[Wave] = []
	#print_debug('fetches waveList with index: ' + str(current_index))
	match current_index:
		#slime, bee, duration
		1:
			wavelist = [
			breaks.large,
			Wave.new(5,5,20),
			breaks.small,
			Wave.new(10,10,20),
			breaks.small,
			Wave.new(15,15,20)
			]
		2:
			wavelist = [
			breaks.medium,
			Wave.new(10,10,20),
			breaks.small,
			Wave.new(15,15,10),
			Wave.new(20,20,15),
			Wave.new(20,20,15),
			]
		3:
			wavelist = [
			breaks.small,
			Wave.new(10,10,15),
			breaks.small,
			Wave.new(15,15,10),
			Wave.new(20,20,15),
			Wave.new(20,20,15)
			]
	
	return wavelist
	#return level0_wavelist
