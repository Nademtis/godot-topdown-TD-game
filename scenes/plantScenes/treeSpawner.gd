extends Node2D
class_name TreeSpawner

const TREE_SPAWN = preload("res://scenes/plantScenes/treeSpawn.tscn")

# Number of trees to spawn each cycle
@export var trees_to_spawn: int = 2

# Spawning interval in seconds
@export var spawn_interval: float = 10.0

@onready var timer: Timer = $Timer

# List of all CollisionShape2D children
var spawn_area_shapes: Array[CollisionShape2D] = []

func _ready() -> void:
	# Gather all CollisionShape2D children into the list
	for child in get_children():
		if child is CollisionShape2D:
			spawn_area_shapes.append(child)
	
	timer.wait_time = spawn_interval

func spawn_trees() -> void:
	for i in range(trees_to_spawn):
		var position = _get_random_position_in_random_shape()
		
		# Instantiate a new tree at the random position
		var tree_container = get_tree().root.get_node("main/TreeSpawnContainer")
		var new_tree = TREE_SPAWN.instantiate()
		new_tree.position = position
		tree_container.add_child(new_tree)

func _get_random_position_in_random_shape() -> Vector2:
	if spawn_area_shapes.is_empty():
		return Vector2.ZERO

	# Pick a random shape from the list
	var random_shape = spawn_area_shapes[randi() % spawn_area_shapes.size()]
	var shape = random_shape.shape
	var random_position = Vector2.ZERO

	if shape is RectangleShape2D:
		var half_extents = shape.extents
		random_position.x = int(randf_range(-half_extents.x, half_extents.x))
		random_position.y = int(randf_range(-half_extents.y, half_extents.y))
	elif shape is CircleShape2D:
		var radius = shape.radius
		var angle = randf() * 2.0 * PI
		var distance = randf() * radius
		random_position.x = cos(angle) * distance
		random_position.y = sin(angle) * distance
	# Add more shapes if needed

	# Transform the local position to global position
	return random_shape.global_position + random_position

func _on_timer_timeout() -> void:
	spawn_trees()
