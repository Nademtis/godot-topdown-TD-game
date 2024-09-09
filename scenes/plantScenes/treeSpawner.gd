extends Node
class_name TreeSpawner

const TREE_SPAWN = preload("res://scenes/plantScenes/treeSpawn.tscn")
# The shape to spawn trees within (assumed to be a CollisionShape2D)
@onready var spawn_area_shape = $CollisionShape2D

# Number of trees to spawn each cycle
@export var trees_to_spawn: int = 2

# Spawning interval in seconds
@export var spawn_interval: float = 10.0
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = spawn_interval
	pass

func spawn_trees() -> void:
	for i in range(trees_to_spawn):
		var position = _get_random_position_in_shape()
		
		# Check for overlaps before spawning the tree
		#if not _is_position_overlapping(position):
		var tree_container = get_tree().root.get_node("main/TreeSpawnContainer")
		var new_tree = TREE_SPAWN.instantiate()
		new_tree.position = position
		tree_container.add_child(new_tree)

func _get_random_position_in_shape() -> Vector2:
	var shape = spawn_area_shape.shape
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
	return spawn_area_shape.global_position + random_position

#func _is_position_overlapping(position: Vector2) -> bool:
	#var space_state = get_world_2d().direct_space_state
	#var query = Physics2DShapeQueryParameters.new()
	#query.shape = spawn_area_shape.shape
	#query.transform = Transform2D(0, position)
	#
	## Check for any overlapping bodies or areas
	#var results = space_state.intersect_shape(query)
	#for result in results:
		#if result.collider is Tree or result.collider is Turret:
			#return true
	#
	#return false

func _on_timer_timeout() -> void:
	spawn_trees()
	pass # Replace with function body.
