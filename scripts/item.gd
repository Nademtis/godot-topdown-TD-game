extends Node

class_name ItemNode

@export var item_resource : ItemResource

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

#@export var item_name : String
#@export var weight : int 


func _ready():
	#TODO set texture and sprite to itemresource variables
	animation_player.play("spawned")

func picked_up():
	queue_free()
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'spawned':
		animation_player.play("idle")
