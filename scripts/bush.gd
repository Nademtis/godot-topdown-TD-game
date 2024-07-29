extends Node2D

@export var hp = 1
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D # only if exist

func _ready():
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("attack"):
		take_damage()
	pass # Replace with function body.
	
func take_damage():
		hp = hp - 1
		animated_sprite_2d.play("bush_hit")

func _on_animated_sprite_2d_animation_finished():
	die()
	pass # Replace with function body.

func die():
	queue_free()
