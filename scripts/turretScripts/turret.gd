extends Node2D

var enemyArray = []
var canShoot = true
@onready var timer = $Timer
@onready var bullet_path = preload("res://scenes/bullet.tscn")


func _process(_delta):
	if enemyArray.size() > 0 && canShoot:
		attack()

func attack():
	canShoot = false
	var firstEnemy = enemyArray[-1].get_parent()
	var bullet = bullet_path.instantiate()
	bullet.target_object = firstEnemy.get_parent()
	add_child(bullet)
	timer.start()
	

func _on_range_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		enemyArray.push_front(area)
	

func _on_range_area_2d_area_exited(area):
	if area.is_in_group("enemy"):
		enemyArray.erase(area)

func _on_timer_timeout():
	canShoot = true
