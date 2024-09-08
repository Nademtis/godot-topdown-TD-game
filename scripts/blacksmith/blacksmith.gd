extends Node2D

@onready var area_2d: Area2D = $Area2D

var player_in_range : bool = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		player_in_range = true
		print('player entered range')
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		player_in_range = false
		print('player exit range')
	pass # Replace with function body.
