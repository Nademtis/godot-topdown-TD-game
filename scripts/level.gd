extends Node

@export var hp : int = 3
@export var current_hp : int = 3
@onready var ui : CanvasLayer = $UI

#hub stuff
@onready var hub_container : Node2D
const HUB = "res://scenes/gameplay/hub.tscn"

@onready var blacksmith: Blacksmith
@onready var player_campfire: Node2D
@onready var player_tent: Sprite2D = $HubContainer/playerTent

func init():
	pass
	#levelManager.set_current_level(self)

func _ready():
	if self.scene_file_path == HUB:
		init_hub()
	pass

#for hub
func init_hub():
	#this method is called when current scene is hub, should init the hub based on HubProgression
	hub_container = $HubContainer
	
	blacksmith = $HubContainer/Blacksmith
	player_campfire = $HubContainer/playerCampfire
	player_tent = $HubContainer/playerTent
	
	disable_all_upgrades()
	
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE] == false:
		pass
	

func disable_all_upgrades() -> void:
	disable_node(blacksmith)
	disable_node(player_campfire)
	disable_node(player_tent)
	

func disable_node(node : Node2D) -> void:
	#disable the node, since it's not unlocked yet
	#node.queue_free()
	node.visible = false
	node.ProcessMode.PROCESS_MODE_DISABLED

#for level
func take_damage():
	current_hp -= 1
	if current_hp <= 0:
		die()
	ui.update_ui_hp(current_hp)
	
func die():
	print("Gameover")
	print_debug("die() is turned off")
	get_tree().reload_current_scene()
