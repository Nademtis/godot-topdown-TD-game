extends Node

class_name Level

@export var hp : int = 3
@export var current_hp : int = 3
@onready var ui : CanvasLayer = $UI
@onready var ground: TileMapLayer = $tilemaps/ground

#hub stuff
@onready var hub_container : Node2D
@onready var log_container: Node2D
const HUB = "res://scenes/gameplay/hub.tscn"
const LEVEL_0 = "res://scenes/gameplay/levels/level0.tscn"

@onready var BUILDABLE_OBJECT = preload("res://scenes/buildable_object.tscn")
const CAMPFIRE_TURNED_OFF = preload("res://assets/world/camp/campfire1.png")
const TENT_PLAYER = preload("res://assets/world/camp/tent1.png")
const BRIDGE = preload("res://assets/world/bridge.png")


@onready var player_campfire: Node2D
@onready var player_tent: Sprite2D
@onready var  bridge1: Node2D
@onready var blacksmith: Blacksmith
var spawn_position = {} # used for spawning the nodes back in at correct location

func _ready():
	if self.scene_file_path == LEVEL_0:
		var lines :Array[String] = [
			"...",
			"Where am i?",
			"How did I get here?",
			"I should probably explore to find out what's going on"
		]
		await get_tree().create_timer(0.5).timeout
		DialogManager.start_dialog($Player.position, lines)
	
	if self.scene_file_path == HUB:
		init_hub()
		audio.play_hub_music()
	elif self.scene_file_path != LEVEL_0:
		audio.play_level_music()


#for hub
func init_hub():
	#this method is called when current scene is hub, should init the hub based on HubProgression
	hub_container = $HubContainer
	log_container = $LogContainer
	
	player_campfire = $HubContainer/playerCampfire
	player_tent = $HubContainer/playerTent
	blacksmith = $HubContainer/Blacksmith
	bridge1 = $HubContainer/Bridge
	update_amount_of_hub_wood()
	set_spawn_position_of_nodes()
	disable_all_nodes()
	update_hub_upgrade_nodes()
	
	
func update_hub_upgrade_nodes() -> void:
	check_bridge_collider()
	
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE] == false:
		display_blueprint(HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE, CAMPFIRE_TURNED_OFF)
		return
	else:
		player_campfire.position = spawn_position[HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE]
		player_campfire.visible = true
		player_campfire.set_process(true)
		
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.PLAYER_TENT] == false:
		display_blueprint(HubProgression.HUB_UPGRADE.PLAYER_TENT, TENT_PLAYER)
		return
	else:
		player_tent.position = spawn_position[HubProgression.HUB_UPGRADE.PLAYER_TENT]
		player_tent.visible = true
		player_tent.set_process(true)
		
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.BRIDGE1] == false:
		var depositArea : CollisionShape2D = get_node_or_null("BuildAreaContainer/bridgeDepositShape")
		display_blueprint(HubProgression.HUB_UPGRADE.BRIDGE1, BRIDGE, depositArea)
		return
	else:
		bridge1.position = spawn_position[HubProgression.HUB_UPGRADE.BRIDGE1]
		bridge1.visible = true
		bridge1.set_process(true)
		
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.BLACKSMITH_TENT] == false:
		display_blueprint(HubProgression.HUB_UPGRADE.BLACKSMITH_TENT, TENT_PLAYER)
		return
	else:
		blacksmith.position = spawn_position[HubProgression.HUB_UPGRADE.BLACKSMITH_TENT]
		blacksmith.visible = true
		blacksmith.set_process(true)
		blacksmith.display_next_upgrades()

func display_blueprint(upgrade : HubProgression.HUB_UPGRADE, texture : Texture2D,  p_collision_shape: CollisionShape2D = null) -> void:
	var blueprint : BuildableObject = BUILDABLE_OBJECT.instantiate()
	
	#optional coll shape for wierd buildings like bridge
	if p_collision_shape == null:
		blueprint.initialize(upgrade, texture)
	else:
		blueprint.initialize(upgrade, texture, p_collision_shape)

	blueprint.global_position = spawn_position[upgrade]
	hub_container.add_child(blueprint)

func check_bridge_collider() -> void:
	var rightTile : Vector2i = Vector2i(-11,-1)
	var leftTile : Vector2i = Vector2i(-14,-1)
	if HubProgression.hub_upgrade_status[HubProgression.HUB_UPGRADE.BRIDGE1]:
		ground.set_cell(rightTile, 0, Vector2i(0, 1), 1)
		ground.set_cell(leftTile, 0, Vector2i(2, 1), 1)
	else:
		ground.set_cell(rightTile, 0, Vector2i(0, 1), 0)
		ground.set_cell(leftTile, 0, Vector2i(2, 1), 0)
		
	

func disable_all_nodes() -> void:
	disable_node(blacksmith)
	disable_node(player_campfire)
	disable_node(player_tent)
	disable_node(bridge1)

func disable_node(node : Node2D) -> void:
	node.visible = false
	node.set_process(false)
	node.position = Vector2(node.position.x + 1000, node.position.y + 1000)

func set_spawn_position_of_nodes() -> void:
	spawn_position = {
	HubProgression.HUB_UPGRADE.PLAYER_CAMPFIRE : player_campfire.global_position,
	HubProgression.HUB_UPGRADE.PLAYER_TENT : player_tent.global_position,
	HubProgression.HUB_UPGRADE.BRIDGE1 : bridge1.global_position,
	HubProgression.HUB_UPGRADE.BLACKSMITH_TENT : blacksmith.global_position,
}
func update_amount_of_hub_wood() -> void:
	var hub_wood_amount : int = PlayerInventory.hub_storage.size()
	for i in range(log_container.get_child_count()):  # Loop through the children of log_container
		var child = log_container.get_child(i)
		if i < hub_wood_amount:
			child.enable()
		else:
			child.disable()
	pass

func remove_one_log_from_hub() -> void:
	var hub_wood_amount : int = PlayerInventory.hub_storage.size()
	if hub_wood_amount == 0:
		#null
		return
		# Get all visible children
	var visible_children: Array = []
	for child in log_container.get_children():
		if child.visible:
			visible_children.append(child)

	if visible_children.size() > 0:
		var random_index = randi() % visible_children.size()
		visible_children[random_index].disable()

#for level
func take_damage():
	current_hp -= 1
	if current_hp <= 0:
		die()
	ui.update_ui_hp(current_hp)
	
func die():
	PlayerInventory.player_inventory.clear()
	PlayerInventory.wagon_storage.clear()
	audio.play_level_music()
	get_tree().reload_current_scene()
