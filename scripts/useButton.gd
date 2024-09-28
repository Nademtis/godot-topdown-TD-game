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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "use" || anim_name == "fail":
		animation_player.play("RESET")
