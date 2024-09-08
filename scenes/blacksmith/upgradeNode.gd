extends Node2D

class_name Upgrade

@export var upgrade_resource : UpgradeResource

@onready var desc_label: Label = $Sprite2D/text/desc_Label
@onready var price_label: Label = $price/price_Label
@onready var upgrade_slot_sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	if !upgrade_resource:
		print_debug('upgradeResource not set - killing upgrade')
		queue_free()
	else:
		desc_label.text = upgrade_resource.desc
		price_label.text = str(upgrade_resource.price)
		upgrade_slot_sprite_2d.texture = upgrade_resource.texture
		
func buy_upgrade():
	if PlayerInventory.coin_amount >= upgrade_resource.price:
		print('player buy')
	else:
		print('not enough money')
	#queueFree?

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		#maybe confirmation (are you sure you want to buy)
		buy_upgrade()


func _on_area_2d_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
