extends Node2D

var trying_to_build = false
const TURRET_BUILDABLE_HOVER = preload("res://scenes/turretScenes/turret_buildable_hover.tscn")
const TURRET_BP = preload("res://scenes/turretScenes/turret_bp.tscn")

@onready var TILEMAP_1: TileMapLayer = get_node_or_null("/root/main/tileMap_1")
var current_bp_hover = null

func _process(_delta):
	
	if trying_to_build:
		var snapped_position = snap_to_grid(get_global_mouse_position())
		current_bp_hover.global_position = snapped_position
		
		if (tile_under_mouse_is_buildable(snapped_position)):
			current_bp_hover.modulate = Color(1,1,1)
		else:
			current_bp_hover.modulate = Color(1, 0, 0)  # Red tint
		
		if (Input.is_action_just_pressed("rightClick") || Input.is_action_just_pressed("esc")):
			trying_to_build = false
			remove_child(current_bp_hover)
			
		if Input.is_action_just_pressed("click") and tile_under_mouse_is_buildable(snapped_position): #TODO AND is area buildable
			#make new BP
			var turret_BP = TURRET_BP.instantiate()
			turret_BP.global_position = current_bp_hover.global_position
			#add BP to main scene in BP container
			var bp_container = get_tree().get_root().get_node("main/BPcontainer")
			bp_container.add_child(turret_BP)
			remove_child(current_bp_hover) #removed the hover
			trying_to_build = false

func snap_to_grid(snapPosition: Vector2) -> Vector2:
	var grid_pos = TILEMAP_1.local_to_map(snapPosition)
	return TILEMAP_1.map_to_local(grid_pos)

func tile_under_mouse_is_buildable(mousePosition : Vector2) -> bool:
	var tile = TILEMAP_1.local_to_map(mousePosition)
	var tileData = TILEMAP_1.get_cell_tile_data(tile)
	var tile_under_mouse_isBuildable = tileData.get_custom_data('isBuildable')
	return tile_under_mouse_isBuildable

func _input(event):
	if event.is_action_pressed("1") && !trying_to_build:
		trying_to_build = true
		current_bp_hover = TURRET_BUILDABLE_HOVER.instantiate()
		add_child(current_bp_hover)
		
	elif event.is_action_pressed("1") && trying_to_build:
		trying_to_build = false
		remove_child(current_bp_hover)
