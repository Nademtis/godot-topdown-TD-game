extends Node2D

class_name UpgradeNode

var upgrade_resource : UpgradeResource = null
@onready var desc_label: Label = $Sprite2D/text/desc_Label
@onready var price_label: Label = $price/price_Label
@onready var upgrade_slot_sprite_2d: Sprite2D = $Sprite2D
@onready var ui: CanvasLayer

#func _init(p_upgrade_resource : UpgradeResource)->void:
	#upgrade_resource = p_upgrade_resource

func _ready() -> void:
	if !upgrade_resource:
		print_debug('upgradeResource not set - killing upgrade')
		queue_free()
	else:
		desc_label.text = str(upgrade_resource.desc)
		price_label.text = str(upgrade_resource.price)
		upgrade_slot_sprite_2d.texture = upgrade_resource.texture

func set_upgrade_resource(p_upgrade_resource: UpgradeResource) -> void:
	#set when spawning new upgradeNodes
	upgrade_resource = p_upgrade_resource

func buy_upgrade():
	if PlayerInventory.coin_amount >= upgrade_resource.price:
		
		PlayerStats.apply_upgrade(upgrade_resource)
		audio.item_coin_pickup()
		get_parent().get_parent().get_parent().get_node("UI").update_coins_ui()
		queue_free()
	else:
		print('not enough money')
	#queueFree?

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		#maybe confirmation (are you sure you want to buy)
		buy_upgrade()
