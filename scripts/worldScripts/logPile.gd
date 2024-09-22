extends Node2D

class_name LogPile

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D


func disable() -> void:
	hide()
	collision_shape_2d.disabled = true
	
func enable() -> void:
	show()
	collision_shape_2d.disabled = false
	
