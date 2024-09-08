extends Node2D

class_name Blacksmith

const UPGRADE_NODE = preload("res://scenes/blacksmith/upgradeNode.tscn")

@onready var area_2d: Area2D = $Area2D
@onready var spawn_point_list : Array[Vector2]
var player_in_range : bool = false

@onready var spawnPoint1 = $spawnPoint1
@onready var spawnPoint2 = $spawnPoint2
@onready var spawnPoint3 = $spawnPoint3

@onready var timer: Timer = $Timer


func _ready() -> void:
	spawn_point_list = [spawnPoint1.position, spawnPoint2.position, spawnPoint3.position]
	display_next_upgrades()
	timer.start()


func display_next_upgrades():
	var upcoming_upgrades : Array[UpgradeResource] = PlayerStats.get_next_upgrades()
	if upcoming_upgrades.size() <= 0:
		print_debug('no more upgrades dude')
		
	for i in range(upcoming_upgrades.size()):
		var upgrade_node : UpgradeNode = UPGRADE_NODE.instantiate()
		upgrade_node.set_upgrade_resource(upcoming_upgrades[i])
		upgrade_node.position = spawn_point_list[i]
		call_deferred("add_child", upgrade_node)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		player_in_range = true
		print('player entered range')
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		player_in_range = false
		print('player exit range')
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	print_debug('updating items')
	display_next_upgrades()
	pass # Replace with function body.
