extends Node2D

@onready var timer = $Timer
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer


const TREE_BABY = preload("res://assets/plants/tree_baby.png")
const TREE_TEEN = preload("res://assets/plants/tree_teen.png")
const TREE_ADULT = preload("res://assets/plants/tree_adult.png")
const TREE_OLD = preload("res://assets/plants/tree_old.png")

@onready var tree_scene_path = preload("res://scenes/plantScenes/tree.tscn")
@export var growth_state : int = 0

func _ready():
	timer.wait_time = randi_range(9,15)
	timer.start()

func _on_timer_timeout():
	grow()

func grow():
	match growth_state:
		0:
			growth_state += 1
			timer.wait_time = randi_range(10,20) #teen -> adult
			timer.start()
			sprite_2d.texture = TREE_TEEN
			animation_player.play("tree_growth")
		1:
			growth_state += 1
			timer.wait_time = randi_range(15,20) #adult -> old
			timer.start()
			sprite_2d.texture = TREE_ADULT
			animation_player.play("tree_growth")
		2:
			sprite_2d.texture = TREE_OLD
			animation_player.play("tree_growth")
			
			#when animation player done with that above. call make tree
			makeTree() #adult -> old

func makeTree():
	var tree_container = get_tree().root.get_node("main/TreeContainer")
	var tree_scene = tree_scene_path.instantiate()
	tree_scene.position = position
	tree_container.add_child(tree_scene)
	queue_free()
