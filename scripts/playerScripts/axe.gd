extends Node2D

@onready var player = $".."
@onready var axe_sprite = $Sprite2D

#attack
@onready var attack_cooldown_timer : Timer = $attackCooldownTimer
@onready var ATTACK_SCENE = preload("res://scenes/playerScenes/attack.tscn")
var can_attack = true

@export var stamina_cost : int = 5
@onready var stamina_controller = $"../StaminaController"

func _ready() -> void:
	var upgrade_listener = get_node("/root/PlayerStats")
	upgrade_listener.connect("upgrade_applied", player_was_upgraded)
	
	attack_cooldown_timer.wait_time = PlayerStats.player_attack_speed

func _input(event):
	if event.is_action_pressed("click"):
		if (can_attack && stamina_controller.can_afford(stamina_cost)):
			attack()
			stamina_controller.use_stamina(stamina_cost)

func attack():
	var point = get_global_mouse_position()
	var attack_instance = ATTACK_SCENE.instantiate()
	
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

func player_was_upgraded():
	attack_cooldown_timer.wait_time = PlayerStats.player_attack_speed
