extends MarginContainer

class_name Textbox

@onready var label: Label = $MarginContainer/Label
@onready var letter_display_timer: Timer = $LetterDisplayTimer

const MAX_WIDTH = 300

var text = ""
var letter_index = 0

var letter_time : float = 0.03
var space_time : float = 0.06
var punctuation_time : float = 0.2

signal finished_displaying()

func display_text (text_to_display):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x
		await resized # wait for y
		custom_minimum_size.y = size.y
		
	global_position.x -= (size.x / 2) * scale.x
	global_position.y -= (size.y + 24)  * scale.y
	
	label.text = ""
	display_letter()
	
func display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	if text.length() <= 3:
		letter_time = 0.1  # Slow down for very short text
	else:
		letter_time = 0.03  # Regular speed for normal text
	
	match text[letter_index]:
		"!", ".", ",", "?":
			letter_display_timer.start(punctuation_time)
		" ":
			letter_display_timer.start(space_time)
		_:
			letter_display_timer.start(letter_time)


func _on_letter_display_timer_timeout() -> void:
	display_letter()
