extends Node

#region MUSIC
@onready var music_synced: AudioStreamPlayer2D = $Music/musicSynced
@onready var music_intro: AudioStreamPlayer2D = $Music/musicIntro

#endregion

#region SFX
#footStep
@onready var step_1 = $Player/footsteps/step1
@onready var step_2 = $Player/footsteps/step2
@onready var step_3 = $Player/footsteps/step3
@onready var step_4 = $Player/footsteps/step4
@onready var footstep_timer = $Player/footsteps/stepTimer
@export var footstep_cooldown : float = 0.4
var footstep_list : Array[AudioStreamPlayer]

#chop
@onready var chop_1 = $Player/chop/chop1
@onready var chop_2 = $Player/chop/chop2
#@onready var chop_3 = $Player/chop/chop3
#@onready var chop_4 = $Player/chop/chop4
var chop_list : Array[AudioStreamPlayer]

#tree
@onready var tree_falling_sfx = $Tree/tree_falling
@onready var tree_creek_sfx = $Tree/tree_creek
#endregion



func _ready():
	
	#footStep
	footstep_list = [step_1, step_2, step_3, step_4]
	footstep_timer.wait_time = footstep_cooldown
	
	#chop
	chop_list= [chop_1, chop_2]
	#chop_list= [chop_1, chop_2, chop_3, chop_4]
	

func foot_step():
	if not footstep_timer.is_stopped():
		return
			
			
	footstep_timer.start()
	footstep_list.pick_random().play()
	
func tree_chop():
	chop_list.pick_random().play()

func tree_creek():
	tree_creek_sfx.play()
	
func tree_falling():
	tree_falling_sfx.play()
	

func _on_music_intro_finished() -> void:
	music_synced.play()
	
	pass # Replace with function body.
