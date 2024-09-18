extends Node

class_name Hubprogression

enum HUB_UPGRADE {
	PLAYER_CAMPFIRE,
	PLAYER_TENT,
	BRIDGE1,
	BLACKSMITH_TENT,
	}

var hub_upgrade_status = {
	HUB_UPGRADE.PLAYER_CAMPFIRE : false,
	HUB_UPGRADE.PLAYER_TENT : false,
	HUB_UPGRADE.BRIDGE1 : false,
	HUB_UPGRADE.BLACKSMITH_TENT : false,
}




func hub_upgrade_finished(hub_upgrade : HUB_UPGRADE) -> void:
	hub_upgrade_status[hub_upgrade] = true
	#unlock next buildable
	pass
