class_name Turret extends Node2D

var enemyArray : Array[Node2D] = []
var canShoot = true
@onready var attack_speed_timer = $Timer
@onready var arrow_path = preload("res://scenes/arrow.tscn")
@onready var animate_archer: AnimatedSprite2D = $archer/AnimatedSprite2D

@onready var l_attack_pos: Node2D = $archer/L_attackPos
@onready var r_attack_pos: Node2D = $archer/R_attackPos
@onready var d_attack_pos: Node2D = $archer/D_attackPos
@onready var u_attack_pos: Node2D = $archer/U_attackPos

func _ready() -> void:
		attack_speed_timer.wait_time = PlayerStats.player_archer_attackspeed
		
		add_to_group("turrets")

func _process(_delta):
	if enemyArray.size() > 0 and canShoot:
		animate_archer.speed_scale = 1.0 / PlayerStats.player_archer_attackspeed
		attack()
	if enemyArray.size() <= 0:
		animate_archer.speed_scale = 1.0
		animate_archer.play('d_idle')

func attack():
	if is_instance_valid(enemyArray[-1]):
		canShoot = false
		attack_anim(enemyArray[-1].global_position)
		attack_speed_timer.start()
	else:
		# Remove invalid enemy from the array
		enemyArray.pop_back()

func attack_anim(enemy_pos : Vector2) -> void:
	audio.turret_load()
	var direction = (enemy_pos - global_position).normalized()
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

func _on_animated_sprite_2d_animation_finished() -> void:
	if enemyArray.size() > 0 and is_instance_valid(enemyArray[-1]):
		var arrow: CharacterBody2D = arrow_path.instantiate()
		arrow.target_object = enemyArray[-1]
		
		match animate_archer.animation:
			'r_attack': 
				arrow.global_position = r_attack_pos.position
			'l_attack':
				arrow.global_position = l_attack_pos.position
			'd_attack':
				arrow.global_position = d_attack_pos.position
			'u_attack':
				arrow.global_position = u_attack_pos.position
		add_child(arrow)
		audio.turret_shoot()
	else:
		# If the target is invalid, remove it from the array
		if enemyArray.size() > 0:
			enemyArray.pop_back()

func _on_range_area_2d_area_entered(area : Area2D):
	if area.is_in_group("enemy"):
		enemyArray.push_front(area.get_parent())

func _on_range_area_2d_area_exited(area):
	if area.is_in_group("enemy"):
		enemyArray.erase(area)

func _on_timer_timeout():
	canShoot = true

func _on_enemy_died(enemy):
	enemyArray.erase(enemy)
