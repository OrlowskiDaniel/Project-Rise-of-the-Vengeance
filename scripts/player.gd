extends CharacterBody2D

class_name Player

@export var player_projectile_node: PackedScene
@export var attack_damage: int = 2  # Damage per attack
@onready var attack_area: Area2D = $AttackArea  # Reference to AttackArea 

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true


var attack_ip = false

const speed = 300
var current_dir = "none"

 
func _ready():
	$AnimatedSprite2D.play("front_idle")
	add_to_group("Player")

 
func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	update_health()

# death statment
	if health <= 0:
		player_alive = false #go back to manu or add death screen or respown
		health = 0
		print("player has been killed")
 
# Player movement + animation movement

func player_movement(_delta):
	var direction = Vector2.ZERO

	# Handle input and set direction vector
	if Input.is_action_pressed("right"):
		current_dir = "right"
		direction.x += 1
	if Input.is_action_pressed("left"):
		current_dir = "left"
		direction.x -= 1
	if Input.is_action_pressed("down"):
		current_dir = "down"
		direction.y += 1
	if Input.is_action_pressed("up"):
		current_dir = "up"
		direction.y -= 1


	velocity = direction.normalized() * speed

	# Set current animation based on movement direction
	if direction != Vector2.ZERO:
		play_anim(1)
		if abs(direction.x) > abs(direction.y):
			current_dir = "right" if direction.x > 0 else "left"
		else:
			current_dir = "down" if direction.y > 0 else "up"
	else:
		play_anim(0)

	# Update velocity and move the player
	move_and_slide()




func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true
	if body.is_in_group("Minion"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false
	if body.is_in_group("Minion"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start() 
		print("Player took damage! Health:", health)

func take_damage(amount: int):
	if health > 0:  
		health -= amount
		print("Player took damage! Health:", health)
		update_health()  # Update health bar
		
		if health <= 0:
			die()
	



func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir

	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true  # Set attacking state
		$deal_attack_timer.start()

		# Play the correct attack animation based on direction
		match dir:
			"right":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("side_attack")
			"left":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("side_attack")
			"down":
				$AnimatedSprite2D.play("front_attack")
			"up":
				$AnimatedSprite2D.play("back_attack")

		print("Player attacked!")

		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("Minion"):
				body.take_damage(attack_damage)
				print("Hit Minion!")  # Debugging
			elif body.is_in_group("Boss"):
				body.take_damage(attack_damage)
				print("Hit Boss!")  # Debugging

func _on_deal_attack_timer_timeout() -> void:
	attack_ip = false
	global.player_current_attack = false


func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$bridge_camera.enabled = false
	elif global.current_scene == "bridge":
		$world_camera.enabled = false
		$bridge_camera.enabled = true
	elif global.current_scene == "boss_room":
		$bridge_camera.enabled = false
		$boss_room_camera.enabled = true


func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	# for toggelling healthbar on/off 
	if health >= 100:
		healthbar.visible = true
	else:
		healthbar.visible = true

func _on_regain_timer_timeout() -> void:
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0

func shoot():
	var projectile = player_projectile_node.instantiate()
 
	projectile.position = global_position
	projectile.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child",projectile)


func _input(event):
	if event.is_action_pressed("attack"):  # When "attack" button is pressed
		attack()
	if event.is_action("shoot"):
		shoot()

func die():
	print("Player has died! Redirecting to death screen...")
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")  # Redirect to death screen
