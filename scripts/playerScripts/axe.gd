extends Node2D

@onready var player = $".."
@onready var axe_sprite = $Sprite2D

#attack
@onready var attackScene = preload("res://scenes/playerScenes/attack.tscn")


func _input(event):
	if event.is_action_pressed("click"):
		attack()

func attack():
	var point = get_global_mouse_position()
	var attack_instance = attackScene.instantiate()
	
	var direction = point - global_position
	var angle_radians = direction.angle()

	attack_instance.rotation = angle_radians + PI

	
	add_child(attack_instance)
	# Wait 0.1 sec
	await get_tree().create_timer(0.5).timeout
	attack_instance.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#var mousePos = get_global_mouse_position()
	
	#for axe placement
	#if player.direction.x < 0:
		#print("left")
	#elif player.direction.x > 0:
		#print("right")
	#elif player.direction.y > 0:
		#print("down")
	#elif player.direction.y < 0:
		#print("up")
	
	#if mousePos.x > player.position.x && mousePos.y > player.position.y: #SE
		#print("SE")
	#elif mousePos.x > player.position.x && mousePos.y < player.position.y: #NE
		#print("NE")
	#elif mousePos.x < player.position.x && mousePos.y < player.position.y: #NW
		#print("NW")
	#elif mousePos.x < player.position.x && mousePos.y > player.position.y: #SW
		#print("SW")
	
	
	#print(mousePos)
	#look_at(get_global_mouse_position())
	
