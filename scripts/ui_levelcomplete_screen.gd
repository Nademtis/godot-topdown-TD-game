extends Control

class_name UiLevelCompleteScreen

func _on_go_home_button_button_down() -> void:
	print("button down")
	levelManager.level_complete()
