extends Node2D

class_name UseButton


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hide()
	pass
	
func show_button():
	show()
	animation_player.play("showButton")
	
func hide_button():
	animation_player.play("hideButton")

func use_button():
	animation_player.play("RESET")
	animation_player.play("use")

func use_button_fail():
	animation_player.play("RESET")
	animation_player.play("fail")
