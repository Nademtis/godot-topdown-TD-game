extends Node

class_name Hubprogression

enum HUB_UPGRADE {
	PLAYER_CAMPFIRE,
	PLAYER_TENT,
	BRIDGE1,
	BLACKSMITH_TENT,
	}

var hub_upgrade_status = {
	HUB_UPGRADE.PLAYER_CAMPFIRE : true,
	HUB_UPGRADE.PLAYER_TENT : true,
	HUB_UPGRADE.BRIDGE1 : true,
	HUB_UPGRADE.BLACKSMITH_TENT : true,
}




func hub_upgrade_finished(hub_upgrade : HUB_UPGRADE) -> void:
	hub_upgrade_status[hub_upgrade] = true
	var main : Level = get_tree().current_scene
	main.update_hub_upgrade_nodes()
	#unlock next buildable
	#spawn the node in the scene
	pass
