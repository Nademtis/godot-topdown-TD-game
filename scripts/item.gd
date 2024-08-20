class_name Item
extends Node


@onready var animation_player = $AnimationPlayer

@export var item_name : String
@export var weight : int 

func _ready():
	animation_player.play("spawned")

func picked_up():
	queue_free()



func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'spawned':
		animation_player.play("idle")
