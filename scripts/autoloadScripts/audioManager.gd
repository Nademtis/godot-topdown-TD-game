extends Node

class_name Audio

#region MUSIC
@export var music_should_play : bool = false
@onready var music_synced: AudioStreamPlayer = %musicSynced
@onready var music_intro: AudioStreamPlayer = $Music/musicIntro

const BASE_LOOP = preload("res://assets/audio/music/base_loop.ogg")
const DRUM_1 = preload("res://assets/audio/music/drum_1.ogg")
const DRUM_2 = preload("res://assets/audio/music/drum_2.ogg")
const INTENSITY_1 = preload("res://assets/audio/music/intensity_1.ogg")

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

#enemy
#slime
const SLIME_DEATH = preload("res://assets/audio/sfx/enemy/slime_death.mp3")
const SLIME_HIT = preload("res://assets/audio/sfx/enemy/slime_hit.wav")

#bee
const BEE_DEATH = preload("res://assets/audio/sfx/enemy/bee_death.wav")
const BEE_HIT = preload("res://assets/audio/sfx/enemy/bee_hit.wav")

#hub
@onready var blacksmith_1: AudioStreamPlayer = $Hub/Blacksmith1
@onready var blacksmith_2: AudioStreamPlayer = $Hub/Blacksmith2

#item
const COIN_DROPPED_1 = preload("res://assets/audio/sfx/item/coin_dropped.wav")
const COIN_DROPPED_2 = preload("res://assets/audio/sfx/item/coin_dropped2.wav")

@onready var coin_pickup_1: AudioStreamPlayer = $Item/CoinPickup
@onready var coin_pickup_2: AudioStreamPlayer = $Item/CoinPickup2
@onready var log_pickup: AudioStreamPlayer = $Item/LogPickup
var COIN_DROPPED_LIST : Array
var coin_pickup_list : Array[AudioStreamPlayer]

#turret
const BOW_LOAD = preload("res://assets/audio/sfx/turret/bow_load.wav")

const BOW_SHOOT_1 = preload("res://assets/audio/sfx/turret/bow_shoot1.wav")
const BOW_SHOOT_2 = preload("res://assets/audio/sfx/turret/bow_shoot2.wav")
const BOW_SHOOT_3 = preload("res://assets/audio/sfx/turret/bow_shoot3.wav")

var TURRET_SHOOT_LIST : Array



#build
@onready var hammer_1: AudioStreamPlayer = $Turret/hammer1
@onready var hammer_2: AudioStreamPlayer = $Turret/hammer2
@onready var hammer_3: AudioStreamPlayer = $Turret/hammer3
var hammer_list : Array[AudioStreamPlayer]

#environment
@onready var bird_timer: Timer = $Environment/birdTimer

@onready var bird_1: AudioStreamPlayer = $Environment/bird1
@onready var bird_2: AudioStreamPlayer = $Environment/bird2
@onready var bird_3: AudioStreamPlayer = $Environment/bird3
@onready var bird_4: AudioStreamPlayer = $Environment/bird4
var bird_list : Array[AudioStreamPlayer]


#cave
@onready var cave_moving_2: AudioStreamPlayer = $Cave/CaveMoving2

#endregion

func _process(_delta: float) -> void:
	if not music_synced.is_playing() && music_should_play:
		music_synced.play()

func _ready():
	#footStep
	footstep_list = [step_1, step_2, step_3, step_4]
	footstep_timer.wait_time = footstep_cooldown
	
	#chop
	chop_list= [chop_1, chop_2]
	#chop_list= [chop_1, chop_2, chop_3, chop_4]
	
	#bird
	bird_list = [bird_1, bird_2, bird_3, bird_4]
	
	#turret
	#turret_shoot_list = [bow_shoot_1, bow_shoot_2, bow_shoot_3]
	hammer_list = [hammer_1, hammer_2, hammer_3]
	TURRET_SHOOT_LIST = [BOW_SHOOT_1, BOW_SHOOT_2, BOW_SHOOT_3]
	
	#item
	COIN_DROPPED_LIST = [COIN_DROPPED_1, COIN_DROPPED_2]
	
	coin_pickup_list = [coin_pickup_1, coin_pickup_2]
	setup_music()

func setup_music():
	var audio_stream : AudioStreamSynchronized = music_synced.stream
	audio_stream.set_sync_stream_volume(2,-60) # mutes drums2

func play_level_music():
	music_should_play = false
	bird_timer.stop()
	
	music_synced.stop()
	music_synced.seek(0)
	
	music_intro.stop()
	music_intro.seek(0)
	
	music_intro.play()

func play_hub_music():
	music_should_play = false
	
	music_intro.stop()
	music_synced.stop()
	
	bird_timer.start()
	pass

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
	
func hammer():
	hammer_list.pick_random().play()

func cave_moving():
	cave_moving_2.play()

func item_coin_pickup():
	coin_pickup_list.pick_random().play()

func item_log_pickup():
	log_pickup.play()
	
func _on_music_intro_finished() -> void:
	music_should_play = true
	pass # Replace with function body.

func _on_bird_timer_timeout() -> void:
	bird_list.pick_random().play()
	bird_timer.wait_time = randf_range(10,20)
	bird_timer.start()
	pass # Replace with function body.
