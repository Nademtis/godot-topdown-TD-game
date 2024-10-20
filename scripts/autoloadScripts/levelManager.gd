extends Node

const LEVEL_PATH = "res://scenes/gameplay/levels/level"  # Base path for levels
const LEVEL_EXTENSION = ".tscn"  # Scene file extension

const HUB = "res://scenes/gameplay/hub.tscn"

var current_scene = null
var current_index : int = 0
var new_level_path: String

var current_scene_is_hub : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer #used for scene transition

func _ready():
	pass

# Call this function when a level is complete
func level_complete():
	current_scene_is_hub = true
	PlayerInventory.return_to_hub()
	animation_player.play('fade_out')
	var new_level_index = current_index + 1
	new_level_path = LEVEL_PATH + str(new_level_index) + LEVEL_EXTENSION
	_deferred_goto_scene(HUB)


func start_next_level():
	if ResourceLoader.exists(new_level_path):
		var new_scene = ResourceLoader.load(new_level_path)
		if new_scene:
			current_scene_is_hub = false
			call_deferred("_deferred_goto_scene", new_level_path)
		pass
	else:
		print_debug("No more levels - Game completed")
	pass	

func _deferred_goto_scene(path):
	if current_scene:
		current_scene.queue_free()
	var s = ResourceLoader.load(path)
	if s == null:
		print_debug("Failed to load scene at: " + path)
		return
		
	current_scene = s.instantiate()
	current_scene.set_name("main")
	if current_scene:
		get_tree().root.add_child(current_scene, true)
		get_tree().current_scene = current_scene
		animation_player.play('fade_in')

func set_current_level(level):
	current_scene = level
	var file_name = level.scene_file_path #level1.tscn
	var match = file_name.substr(5, file_name.length() - 10)
	current_index = match.to_int()

func get_current_level_wavelist():
	var breaks = {
		"small": Wave.new(0,0,0,0,5),
		"medium":Wave.new(0,0,0,0,10),
		"large": Wave.new(0,0,0,0,15)
	}
	
	var wavelist : Array[Wave] = []
	print_debug('fetches waveList with index: ' + str(current_index))
	match current_index:
		#slime, bee, rat, ogre, duration
		1:
			wavelist = [
			breaks.large,
			Wave.new(3,3,0,0,20),
			breaks.medium,
			Wave.new(4,4,0,0,20),
			breaks.small,
			Wave.new(10,5,0,0,25)
			]
		2:
			wavelist = [
			breaks.large,
			Wave.new(7,7,0,0,20),
			breaks.small,
			Wave.new(12,10,0,0,20),
			breaks.small,
			Wave.new(18,18,0,0,25),
			]
		3:
			wavelist = [
			breaks.medium,
			Wave.new(11,11,0,0,20),
			breaks.small,
			Wave.new(15,15,0,0,20),
			breaks.small,
			Wave.new(22,22,0,0,25),
			]
		4:
			wavelist = [
			breaks.medium,
			Wave.new(3,3,10,10,25),
			breaks.medium,
			Wave.new(17,17,0,0,25),
			breaks.small,
			Wave.new(30,26,0,0,30),
			]
		5:
			wavelist = [
			breaks.small,
			Wave.new(15,15,0,0,20),
			#breaks.small,
			Wave.new(5,20,0,0,35),
			Wave.new(25,25,0,0,20),
			breaks.small,
			Wave.new(36,36,0,0,30),
			]
		6:
			wavelist = [
			breaks.small,
			Wave.new(25,25,0,0,20),
			#breaks.small,
			Wave.new(30,5,0,0,30),
			Wave.new(25,25,0,0,20),
			breaks.small,
			Wave.new(50,50,0,0,40),
			]
		7:
			wavelist = [
			#breaks.small,
			Wave.new(10,10,0,0,30),
			breaks.small,
			Wave.new(30,5,0,0,30),
			Wave.new(25,25,0,0,20),
			breaks.small,
			Wave.new(25,25,0,0,30),
			Wave.new(45,45,0,0,40),
			breaks.small,
			]
		8:
			wavelist = [
			#breaks.small,
			Wave.new(12,12,0,0,25),
			breaks.small,
			Wave.new(35,10,0,0,35),
			Wave.new(30,30,0,0,25),
			breaks.small,
			Wave.new(30,30,0,0,30),
			Wave.new(100,80,0,0,50),
			breaks.small,
			]
		_:
			push_warning("no wavelist for this index" + str(current_index))
	
	return wavelist
	#return level0_wavelist
