extends CharacterBody2D

@export var bullet_speed = 150
var target_object = null
var target_is_alive = true

func _ready():
	pass

func _process(delta):
	#check if alive
	if target_object.get_child_count() == 0:
		target_is_alive = false
	else:
		target_is_alive = true
	
	
	#move bullet towards enemy
	if target_is_alive:
		var direction = (target_object.global_position - global_position).normalized()
		global_position += direction * bullet_speed * delta
	else:
		queue_free()



func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		enemy.take_damage()
		queue_free()
