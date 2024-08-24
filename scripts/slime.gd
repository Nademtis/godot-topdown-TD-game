extends Node2D

@export var hp : int = 3
@export var speed = 40
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

func _ready():
	if randf() > 0.5:
		#animated_sprite.play("purpleSlime")
		animated_sprite.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# for moving slime - uses pathfollow2d progress
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	
	if get_parent().get_progress_ratio() >= 1:
		get_tree().root.get_node("main").take_damage() # damages player
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

func die():
	#var gParent = get_parent().get_parent() #kill/destroy this grand parent
	#gParent.queue_free()
	queue_free()
	
	
