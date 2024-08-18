extends Node

@onready var stamina_bar = $StaminaBar
@export var current_stamina : float = 100
@export var max_stamina : float = 100

@onready var regeneration_cool_down_timer = $regenerationCoolDownTimer
var can_regenerate = true
@onready var regeneration_rate : float = 15

func _ready():
	stamina_bar.value = current_stamina

func _process(delta):
	
	if (current_stamina == max_stamina):
		stamina_bar.visible = false
	else:
		stamina_bar.visible = true
	
	if current_stamina < max_stamina && can_regenerate:
		current_stamina += regeneration_rate * delta
		if current_stamina > max_stamina:
			current_stamina = max_stamina
		update_UI()
		
func update_UI():
	stamina_bar.value = current_stamina

func can_afford(price:int):
	if current_stamina - price > 0:
		return true
	else:
		return false

func use_stamina(price):
	#current_stamina -= price
	update_UI()
	can_regenerate = false
	regeneration_cool_down_timer.start()
	
func _on_regeneration_cool_down_timer_timeout():
	can_regenerate = true
