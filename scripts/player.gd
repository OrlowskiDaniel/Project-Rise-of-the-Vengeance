extends CharacterBody2D
 
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

const speed = 300
var current_dir = "none"
 
func _ready():
	$AnimatedSprite2D.play("front_idle")

 
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
		self.queue_free()
 
# Player movement + animation movement
func player_movement(delta): 
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
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


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 49
		enemy_attack_cooldown = false
		$attack_cooldown.start() 
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimetedSprite2D.flip_h = false
			$AnimetedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimetedSprite2D.flip_h = true
			$AnimetedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
			

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false


func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$bridge_camera.enabled = false
	elif global.current_scene == "bridge":
		$world_camera.enabled = false
		$bridge_camera.enabled = true


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
	
