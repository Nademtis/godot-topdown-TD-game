extends Node2D

var trying_to_build = false
var TURRET_STAND_path = preload("res://assets/turretStand.png")
const TURRET_BUILDABLE_HOVER = preload("res://scenes/turretScenes/turret_buildable_hover.tscn")
const TURRET_BP = preload("res://scenes/turretScenes/turret_bp.tscn")

var current_bp_hover = null

func _process(_delta):
	if trying_to_build:
		current_bp_hover.global_position = get_global_mouse_position() #show the build position at mouse
		if (Input.is_action_just_pressed("rightClick") || Input.is_action_just_pressed("esc")):
			trying_to_build = false
			remove_child(current_bp_hover)
			
		if (Input.is_action_just_pressed("click")):
			#make new BP
			var turret_BP = TURRET_BP.instantiate()
			turret_BP.global_position = current_bp_hover.global_position
			#add BP to main scene in BP container
			var bp_container = get_tree().get_root().get_node("main/BPcontainer")
			bp_container.add_child(turret_BP)
			remove_child(current_bp_hover) #removed the hover
			trying_to_build = false



func _input(event):
	if event.is_action_pressed("1") && !trying_to_build:
		trying_to_build = true
		current_bp_hover = TURRET_BUILDABLE_HOVER.instantiate()
		add_child(current_bp_hover)
		
	elif event.is_action_pressed("1") && trying_to_build:
		trying_to_build = false
		remove_child(current_bp_hover)
