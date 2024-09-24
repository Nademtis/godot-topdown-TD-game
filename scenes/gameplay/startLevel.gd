extends Sprite2D

class_name StartLevel

@onready var area_next_level: Area2D = $AreaNextLevel
@onready var collision_blocker: CollisionShape2D = $StaticBody2D/CollisionBlocker
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.hide()
	pass # Replace with function body.



func _on_area_next_level_area_entered(area: Area2D) -> void:
	levelManager.start_next_level()
	pass # Replace with function body.


func _on_area_empty_inventory_check_area_entered(area: Area2D) -> void:
	if PlayerInventory.player_inventory.size() <= 0 && PlayerInventory.wagon_storage.size() <= 0:
		print("allowed to start level")
		collision_blocker.call_deferred("set_disabled", true)
	else:
		collision_blocker.call_deferred("set_disabled", false)
		label.show()
		print("not allowed to start level")
		


func _on_area_empty_inventory_check_area_exited(area: Area2D) -> void:
	label.hide()
	pass # Replace with function body.
