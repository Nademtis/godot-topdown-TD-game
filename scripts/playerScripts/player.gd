extends CharacterBody2D


var speed : int = PlayerStats.player_move_speed  # speed in pixels/sec
var sprint_multiplier : float = PlayerStats.player_sprint_multiplier


@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D

@onready var stamina_controller = $StaminaController

@export var stamina_drain_rate : float = 0.35
@export var stamina_sprint_cost : float = 2.5
@onready var stamina_drain_timer : Timer = $staminaDrainTimer

#player movement
var direction
var is_sprinting = false

var debug_pos_for_stuck : Vector2 

#for scene change safety
var can_move = false
@onready var can_move_timer: Timer = $canMoveTimer

#camera zoom
var old_camera
@export var zoom_speed = 0.05

func _ready():
	
	#for debug test
	debug_pos_for_stuck = global_position
	
	var upgrade_listener = get_node("/root/PlayerStats")
	upgrade_listener.connect("upgrade_applied", player_was_upgraded)
	
	old_camera = camera.zoom
	stamina_drain_timer.wait_time = stamina_drain_rate
	can_move_timer.start()

func _process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("stuck"):
		global_position = debug_pos_for_stuck
	
	#handle sprinting
	if Input.is_action_pressed("sprint") && stamina_controller.can_afford(stamina_sprint_cost):
		if stamina_drain_timer.is_stopped(): #start drain timer
			stamina_drain_timer.start()
		is_sprinting = true
		velocity = direction * speed * sprint_multiplier * delta
	else:
		is_sprinting = false
		velocity = direction * speed * delta
	
	if can_move:
		if direction:
			audio.foot_step()
		handle_animation()
		update_camera_zoom(delta)
		move_and_slide()
	
func handle_animation():
	if direction:
		animated_sprite.play("walk")
		#for flipping player
		if direction.x <0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")
	pass
	
func update_camera_zoom(_delta):
	var target_zoom = Vector2()
	if is_sprinting:
		target_zoom = Vector2(2.3, 2.3)
	else:
		target_zoom = old_camera
	
	# Interpolate towards target zoom
	camera.zoom.x = lerp(camera.zoom.x, target_zoom.x, zoom_speed)
	camera.zoom.y = lerp(camera.zoom.y, target_zoom.y, zoom_speed)

func player_was_upgraded():
	speed = PlayerStats.player_move_speed  # speed in pixels/sec
	sprint_multiplier = PlayerStats.player_sprint_multiplier

func _on_stamina_drain_timer_timeout():
	stamina_controller.use_stamina(stamina_sprint_cost)
	pass # Replace with function body.


func _on_can_move_timer_timeout() -> void:
	can_move = true
	pass # Replace with function body.
