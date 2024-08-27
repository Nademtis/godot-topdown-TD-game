class_name Enemy extends Node2D

@export var hp : int = 3
@export var speed : float = 40 
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var previous_pos : Vector2


func _ready():
	var area2D:Area2D = get_node('Area2D')
	area2D.area_entered.connect(enemy_hit)
	animated_sprite.animation_finished.connect(kill)
	
func _process(delta):

	if hp >= 1:
		# for moving slime - uses pathfollow2d progress
		get_parent().set_progress(get_parent().get_progress() + speed * delta)
		
		var new_pos = global_position
		swap_movement_animation(new_pos)
		previous_pos = new_pos
		
		if get_parent().get_progress_ratio() >= 1:
			get_tree().root.get_node("main").take_damage() # damages player
			queue_free()

func swap_movement_animation(new_pos : Vector2) -> void:
	var direction = new_pos - previous_pos
	
	if abs(direction.x) > abs(direction.y): # Moving horizontally
		if direction.x > 0:
			animated_sprite.play("L_Walk")
			animated_sprite.flip_h = true
		else:
			animated_sprite.play("L_Walk")
			animated_sprite.flip_h = false
			
	else: # Moving vertically
		if direction.y > 0:
			animated_sprite.play("D_Walk")
		else:
			animated_sprite.play("U_Walk")
	
func enemy_hit(area):
	if area.is_in_group("attack"):
		take_damage()
	pass # Replace with function body.

func take_damage():
		hp = hp - 1
		animation_player.play("enemy_hit") #making red on hit
		if hp < 1:
			die()
			area_2d.set_deferred("monitoring", false)
			

func die():
	get_tree().call_group("turrets", "_on_enemy_died", self)
	speed = 0 # since we dead
	
	var firstLetter : String = animated_sprite.animation.substr(0, 1)
	var death_animation : String = firstLetter + '_Death'
	animated_sprite.play(death_animation)
	#animated_sprite.animation_finished.connect(kill)
	#kill when done
	
func kill():
	get_parent().queue_free() #should probably also kill the parent (pathfollow2d)
	#queue_free()
