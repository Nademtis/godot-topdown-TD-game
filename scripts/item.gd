extends RigidBody2D

class_name ItemNode

@export var item_resource : ItemResource

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $spawnSFX
var temp_stream = null

#@export var item_name : String
#@export var weight : int 


func initialize(p_item_resource: ItemResource, p_spawn_SFX = null) -> void:
	item_resource = p_item_resource
	if p_spawn_SFX != null:
		temp_stream = p_spawn_SFX

func _ready():
	if temp_stream != null:
		audio_stream_player_2d.stream = temp_stream
		audio_stream_player_2d.play()
	
	if item_resource:
		sprite_2d.texture = item_resource.texture
		animation_player.play("spawned")

func picked_up():
	queue_free()
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'spawned':
		animation_player.play("idle")
