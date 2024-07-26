extends CharacterBody2D


@export var speed = 9*1000  # speed in pixels/sec
@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D

#player movement
var direction
var is_sprinting = false

#camera zoom
var old_camera
@export var zoom_speed = 0.05

func _ready():
	old_camera = camera.zoom


	
func _process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	#update animation
	handle_animation()
	
	#handle sprinting
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		velocity = direction * speed * 1.3 * delta
	else:
		is_sprinting = false
		velocity = direction * speed * delta
	
	# smooth camera zoom
	update_camera_zoom(delta)
	
	#move player
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




