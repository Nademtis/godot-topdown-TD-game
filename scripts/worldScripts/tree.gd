extends Node2D

var hp = 3
#@onready var log_path = preload("res://scenes/itemNode.tscn")
@onready var animation_player = $AnimationPlayer
@onready var top_sprite_2d = $topSprite2D

@onready var cpu_particles_2d = $CPUParticles2D
const LEAF_PARTICLE_1 = preload("res://assets/particle/leaf_particle1.png")

var anim_shouldChopRight = true

func _ready():
	cpu_particles_2d.texture = LEAF_PARTICLE_1

func _on_area_2d_area_entered(area):
	if area.is_in_group("attack"):
		take_damage()
	pass # Replace with function body.

func take_damage():
		cpu_particles_2d.emitting = true
		hp = hp - 1
		audio.tree_chop()
		
		animateChop()
		
		if hp == 1:
			audio.tree_creek()
		if hp < 1:
			audio.tree_falling()

func die():
	#spawn item
	var log_item : ItemNode = ItemSpawner.get_item(ItemSpawner.ITEM.LOG) #ITEM enum is not in scope. how to fix
	var item_container = get_tree().root.get_node("main").get_node("Items")
	log_item.position = position
	
	#kill 
	if item_container:
		item_container.call_deferred("add_child", log_item)
	else:
		print("no item container in root")
	call_deferred("queue_free") # call after a psysics/process frame 
	
func animateChop():
	if anim_shouldChopRight && hp > 0:
		anim_shouldChopRight = false
		animation_player.play("hitRight")
	elif !anim_shouldChopRight && hp > 0:
		anim_shouldChopRight = true
		animation_player.play("hitLeft")
	else: #die anim
		var player_position = get_tree().root.get_node("main").get_node("Player").global_position
		if player_position.x > global_position.x:
			animation_player.play("dieLeft")
		else:
			animation_player.play("dieRight")
		

func _on_animation_player_animation_finished(anim_name):
	if anim_name=="dieRight" || anim_name=="dieLeft":
		die()
