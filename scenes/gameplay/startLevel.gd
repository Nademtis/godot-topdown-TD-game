extends Sprite2D

class_name StartLevel

@onready var area_2d: Area2D = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_area_2d_area_entered(_area: Area2D) -> void:
	levelManager.start_next_level()
	pass # Replace with function body.
