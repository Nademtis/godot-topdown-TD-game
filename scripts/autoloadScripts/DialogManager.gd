extends Node

@onready var textbox_scene = preload("res://scenes/dialogue/textbox.tscn")

var dialog_lines : Array[String] = []
var current_line_index = 0

var text_box : Textbox
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position: Vector2, lines: Array[String]):
	if is_dialog_active:
		return #don't start new dialog if one is active
	
	dialog_lines = lines
	text_box_position = position
	show_text_box()
	is_dialog_active = true
	
func show_text_box():
	text_box = textbox_scene.instantiate()
	text_box.finished_displaying.connect(on_text_box_finished_displaying)
	#get_tree().root.add_child(text_box)
	get_tree().root.call_deferred("add_child", text_box)  # Use call_deferred here
	text_box.global_position = text_box_position
	#text_box.display_text(dialog_lines[current_line_index])
	text_box.call_deferred("display_text", dialog_lines[current_line_index])
	can_advance_line = false
	
func on_text_box_finished_displaying():
	print("dialog is ready")
	can_advance_line = true
	
func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("click") || event.is_action_pressed("use")  &&
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size(): #done with dialog
			is_dialog_active = false
			current_line_index = 0
			return
		show_text_box()
