class_name Enemy extends Node2D

@export var hp : float = 3
@export var speed : float = 40 
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var previous_pos : Vector2

@onready var sfx_death: AudioStreamPlayer2D = $SFXDeath
@onready var sfx_hit: AudioStreamPlayer2D = $SFXHit


func _ready():
	setup_SFX()
	#var area2D:Area2D = get_node('Area2D')
	area_2d.area_entered.connect(enemy_hit)
	#animated_sprite.animation_finished.connect(kill)
	
func _process(delta):
	if hp > 0:
		# for moving slime - uses pathfollow2d progress
		get_parent().set_progress(get_parent().get_progress() + speed * delta)
		
		var new_pos = global_position
		swap_movement_animation(new_pos)
		previous_pos = new_pos
		
		if get_parent().get_progress_ratio() >= 1:
			get_tree().root.get_node("main").take_damage() # damages player
			queue_free()

func swap_movement_animation(new_pos : Vector2) -> void:
	var direction = new_pos - previous_pos
	
	if abs(direction.x) > abs(direction.y): # Moving horizontally
		if direction.x > 0:
			animated_sprite.play("L_Walk")
			animated_sprite.flip_h = true
		else:
			animated_sprite.play("L_Walk")
			animated_sprite.flip_h = false
			
	else: # Moving vertically
		if direction.y > 0:
			animated_sprite.play("D_Walk")
		else:
			animated_sprite.play("U_Walk")
	
func enemy_hit(area):
	if area.is_in_group("attack"):
		take_damage_from_player()
	pass # Replace with function body.

func take_damage_from_player():
		hp = hp - PlayerStats.player_attack_damage
		animation_player.play("enemy_hit") #making red on hit
		if hp <= 0:
			sfx_death.play()
			die()
			area_2d.set_deferred("monitoring", false)
		else:
			sfx_hit.play()

func setup_SFX() -> void:
	match name:
		"Slime":
			sfx_hit.stream = audio.SLIME_HIT
			sfx_death.stream = audio.SLIME_DEATH
		"Bee":
			sfx_hit.stream = audio.BEE_HIT
			sfx_death.stream = audio.BEE_DEATH

func take_damage_from_arrow():
		hp = hp - PlayerStats.player_archer_damage
		animation_player.play("enemy_hit") #making red on hit
		if hp <= 0:
			sfx_death.play()
			die()
			area_2d.set_deferred("monitoring", false)
		else:
			sfx_hit.play()

func die():
	spawn_item()
	get_tree().call_group("turrets", "_on_enemy_died", self)
	#speed = 0 # since we dead
	
	#play correct death anim based on direction
	var firstLetter : String = animated_sprite.animation.substr(0, 1)
	print(firstLetter + '_Death' )
	var death_animation : String = firstLetter + '_Death' 
	animated_sprite.play(death_animation)
	await get_tree().create_timer(0.5).timeout
	get_parent().queue_free()
	
func kill():
	get_parent().queue_free()

func spawn_item():
	#print('mob is called: ' + str(self.name)) #might want to use name for spawnRate
	var randNum = randf()
	if (randNum > 0.90):
		var coin_item  = ItemSpawner.get_item(ItemSpawner.ITEM.COIN)
		var item_container = get_tree().root.get_node("main").get_node("Items")
		coin_item.position = global_position

		if item_container:
			item_container.call_deferred("add_child", coin_item)
	
	
