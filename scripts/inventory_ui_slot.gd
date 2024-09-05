extends Panel

class_name InventorySlot

@onready var item_display: Sprite2D = $item_display

func update(item : ItemResource):
	if !item:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.texture
		
