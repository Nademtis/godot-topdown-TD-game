extends Node2D

@onready var player = $".."
@onready var axe_sprite = $Sprite2D

@onready var attack_cooldown_timer = $attackCooldownTimer
var can_attack = true

@onready var stamina_controller = $"../StaminaController"
@export var stamina_cost : int = 5

#attack
@onready var attackScene = preload("res://scenes/playerScenes/attack.tscn")


func _input(event):
	if event.is_action_pressed("click"):
		if (can_attack && stamina_controller.can_afford(stamina_cost)):
			attack()
			stamina_controller.use_stamina(stamina_cost)

func attack():
	var point = get_global_mouse_position()
	var attack_instance = attackScene.instantiate()
	
	var direction = point - global_position
	var angle_radians = direction.angle()
	attack_instance.rotation = angle_radians + PI

	#cooldown stuff
	can_attack = false
	attack_cooldown_timer.start()

	add_child(attack_instance)
	await get_tree().create_timer(0.5).timeout
	attack_instance.queue_free()


func _on_attack_cooldown_timer_timeout():
	can_attack = true
