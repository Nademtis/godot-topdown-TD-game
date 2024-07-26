extends Node2D

@export var hp : int = 3
@export var speed = 40
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# for moving slime - uses pathfollow2d progress
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	
	if get_parent().get_progress_ratio() >= 1:
		#print("slime hit end")
		queue_free()
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("attack"):
		take_damage()
	pass # Replace with function body.

func take_damage():
		hp = hp - 1
		animation_player.play("slime_hit") #making red on hit
		if hp < 1:
			die()
			
		
		#var tween = get_tree().create_tween()
		#animated_sprite.self_modulate = Color(1,0,0)
		#tween.tween_property(animated_sprite, "self_modulate", Color.WHITE, 0.18)
		#tween.tween_property(animated_sprite, "scale", Vector2(), 1)

func die():
	#var gParent = get_parent().get_parent() #kill/destroy this grand parent
	#gParent.queue_free()
	queue_free()
	
	
