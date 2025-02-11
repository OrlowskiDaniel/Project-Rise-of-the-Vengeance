extends CharacterBody2D

var speed = 75
var player_chase = false
var player = null

var health = 30
var player_inattack_zone = false
var can_take_dmg = true

func _physics_process(_delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		
		# Animation missing

func _on_player_detection_body_entered(body: Node2D) -> void:
	player = body 
	player_chase = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true
	


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_dmg == true:
			health = health - 5
			$take_dmg_cooldown.start()
			can_take_dmg = false
			print("enemy health = ", health)
			if health <= 0:
				self.queue_free()
	


func _on_take_dmg_cooldown_timeout() -> void:
	can_take_dmg = true
	
func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
