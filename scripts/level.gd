extends Node

class_name Level

@export var hp : int = 3
@export var current_hp : int = 3
@onready var ui : CanvasLayer = $UI

#hub stuff
@onready var hub_container : Node2D
const HUB = "res://scenes/gameplay/hub.tscn"

@onready var BUILDABLE_OBJECT = preload("res://scenes/buildable_object.tscn")
const CAMPFIRE_TURNED_OFF = preload("res://assets/world/camp/campfire1.png")
const TENT_PLAYER = preload("res://assets/world/camp/tent1.png")

@onready var player_campfire: Node2D
@onready var player_tent: Sprite2D
@onready var bridge1: Node2D
@onready var blacksmith: Blacksmith
var spawn_position = {} # used for spawning the nodes back in at correct location

func _ready():
	if self.scene_file_path == HUB:
		init_hub()
	pass

#for hub
func init_hub():
	#this method is called when current scene is hub, should init the hub based on HubProgression
	hub_container = $HubContainer
	
	player_campfire = $HubContainer/playerCampfire
	player_tent = $HubContainer/playerTent
	blacksmith = $HubContainer/Blacksmith
	set_spawn_position_of_nodes()
	disable_all_nodes()
	update_hub_upgrade_nodes()
	
	
func update_hub_upgrade_nodes() -> void:
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE] == false:
		var log = ItemSpawner.LOG_RESOURCE
		var p_item_cost_array : Array[ItemResource] = [log, log, log]
		display_blueprint(p_item_cost_array, HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE, CAMPFIRE_TURNED_OFF)
		return
	else:
		player_campfire.position = spawn_position[HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE]
		player_campfire.visible = true
		player_campfire.set_process(true)
		
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.PLAYER_TENT] == false:
		var log = ItemSpawner.LOG_RESOURCE
		var p_item_cost_array : Array[ItemResource] = [log, log, log, log, log]
		display_blueprint(p_item_cost_array, HubProgression.HUB_UPGRADE.PLAYER_TENT, TENT_PLAYER)
		return
	else:
		player_tent.position = spawn_position[HubProgression.HUB_UPGRADE.PLAYER_TENT]
		player_tent.visible = true
		player_tent.set_process(true)
		
		#TODO make bridge
		#TODO make 

func display_blueprint(p_item_cost_array : Array[ItemResource], upgrade : HubProgression.HUB_UPGRADE, texture : Texture2D) -> void:
	var blueprint : BuildableObject = BUILDABLE_OBJECT.instantiate()
	blueprint.initialize(upgrade, p_item_cost_array, texture)
	blueprint.global_position = spawn_position[upgrade]
	hub_container.add_child(blueprint)


func disable_all_nodes() -> void:
	disable_node(blacksmith)
	disable_node(player_campfire)
	disable_node(player_tent)

func disable_node(node : Node2D) -> void:
	node.visible = false
	node.set_process(false)
	node.position = Vector2(node.position.x + 1000, node.position.y + 1000)

func set_spawn_position_of_nodes() -> void:
	spawn_position = {
	HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE : player_campfire.global_position,
	HubProgression.HUB_UPGRADE.PLAYER_TENT : player_tent.global_position,
	#HubProgression.HUB_UPGRADE.BRIDGE1 : bridge1.global_position,
	HubProgression.HUB_UPGRADE.BLACKSMITH_TENT : blacksmith.global_position,
}

#for level
func take_damage():
	current_hp -= 1
	if current_hp <= 0:
		die()
	ui.update_ui_hp(current_hp)
	
func die():
	#null
	print_debug("die() is turned off")
	get_tree().reload_current_scene()
