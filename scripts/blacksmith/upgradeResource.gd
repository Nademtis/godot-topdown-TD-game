extends Resource

class_name UpgradeResource

@export var desc : String
@export var price : int
@export var texture : Texture2D

@export var upgrade_variable : String
@export var upgrade_amount : float

func _init(p_desc: String, p_price: int, p_texture: Texture2D, p_upgrade_variable : String, p_upgrade_amount : float) -> void:
	desc = p_desc
	price = p_price
	texture = p_texture
	upgrade_variable = p_upgrade_variable
	upgrade_amount = p_upgrade_amount
