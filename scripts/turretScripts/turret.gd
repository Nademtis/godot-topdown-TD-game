extends Node2D

var enemyArray = []
var canShoot = true
@onready var timer = $Timer
@onready var arrow_path = preload("res://scenes/arrow.tscn")
@onready var animate_archer: AnimatedSprite2D = $archer/AnimatedSprite2D


func _process(_delta):
	if enemyArray.size() > 0 && canShoot:
		attack()

func attack():
	canShoot = false
	var firstEnemy = enemyArray[-1].get_parent()
	attack_anim(firstEnemy)
	
	var arrow = arrow_path.instantiate()
	arrow.target_object = firstEnemy.get_parent()
	add_child(arrow)
	timer.start()
	
func attack_anim(enemyPos) -> void:
	var direction = (enemyPos.global_position - global_position).normalized()
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animate_archer.play('r_attack')
		else:
			animate_archer.play('l_attack')
	else:
		if direction.y > 0:
			animate_archer.play('d_attack')
		else:
			animate_archer.play('u_attack')
			

func _on_range_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		enemyArray.push_front(area)
	

func _on_range_area_2d_area_exited(area):
	if area.is_in_group("enemy"):
		enemyArray.erase(area)

func _on_timer_timeout():
	canShoot = true
