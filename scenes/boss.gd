extends CharacterBody2D

@export var speed: float = 100.0
@export var teleport_range: float = 300.0
@export var projectile_scene: PackedScene
@export var minion_scene: PackedScene
@export var min_x: float = 0
@export var max_x: float = 1000.0
@export var min_y: float = 0
@export var max_y: float = 600.0
@export var max_health: int = 300  # Boss max health
@export var slash_damage: int = 5  # Damage of the slash attack
@export var slash_range: float = 100.0  # Range for melee attack

@onready var move_timer: Timer = $MoveTimer
@onready var teleport_timer: Timer = $TeleportTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var summon_timer: Timer = $SummonTimer
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D  
@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var invincibility_timer: Timer = $Invincibility

var can_take_damage: bool = true  # Damage cooldown
var direction: Vector2 = Vector2.ZERO
var health: int  # Current health



func _ready():
	add_to_group("Boss")
	health = max_health
	update_health_bar()
	
	animation.play("idle")  # Start with idle animation

	move_timer.timeout.connect(change_direction)
	teleport_timer.timeout.connect(teleport)
	attack_timer.timeout.connect(attack)
	summon_timer.timeout.connect(summon_minion)
	invincibility_timer.timeout.connect(enable_damage)

	move_timer.start(1.5)
	teleport_timer.start(5.0)
	attack_timer.start(2.0)
	summon_timer.start(7.0)

func _process(delta):
	position += direction * speed * delta
	update_animation()

func change_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func update_animation():
	if animation.animation == "slash" or animation.animation == "projectile" or animation.animation == "summon":
		return  # Don't override attack animations

	if direction.length() > 0:
		animation.play("walk")
	else:
		animation.play("idle")

func teleport():
	var new_position: Vector2
	var max_attempts = 20

	for i in range(max_attempts):
		new_position = global_position + Vector2(randf_range(-teleport_range, teleport_range), randf_range(-teleport_range, teleport_range))
		new_position.x = clamp(new_position.x, min_x, max_x)
		new_position.y = clamp(new_position.y, min_y, max_y)

		if not is_position_colliding(new_position):
			global_position = new_position
			return  

	print("No valid teleport position found!")

func is_position_colliding(position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_bodies = true
	query.collide_with_areas = false
	
	var result = space_state.intersect_point(query)
	return result.size() > 0  

# Attack function
func attack():
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var distance = global_position.distance_to(player.global_position)

		if distance <= slash_range:
			slash_attack(player)  # Perform melee attack
		else:
			shoot_projectile()  # Perform ranged attack

# Slash attack at melee range
func slash_attack(player):
	animation.play("slash")

	await get_tree().create_timer(0.5).timeout  # Add a small delay instead of waiting for animation
	
	if global_position.distance_to(player.global_position) <= slash_range:
		player.take_damage(slash_damage)  # Ensure player has a take_damage function
		print("Boss slashed player!")
	animation.play("idle")  # Return to idle animation


# Projectile attack
func shoot_projectile():
	if projectile_scene:
		animation.play("projectile")

		await get_tree().create_timer(0.5).timeout  # Wait before shooting

		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			var direction = (player.global_position - global_position).normalized()
			projectile.direction = direction  # Set spear direction
		get_parent().add_child(projectile)

	animation.play("idle")  # Return to idle

# Summon minion 
func summon_minion():
	if minion_scene:
		animation.play("summon")

		await get_tree().create_timer(0.8).timeout  # delay before summoning

		var minion = minion_scene.instantiate()
		minion.global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		get_parent().add_child(minion)

	animation.play("idle")  # return to idle


func take_damage(amount: int):
	if can_take_damage:
		health -= amount  # reduce boss HP
		health = max(health, 0)  # prevent negative HP
		update_health_bar()  # update UI

		print("Boss HP:", health, " - HealthBar Value:", health_bar.value) # Debugging
		
		can_take_damage = false
		invincibility_timer.start(0.4) 
	

	if health <= 0:
		die()  # kill the boss if health reaches 0

func update_health_bar():
	if health_bar:
		health_bar.value = (float(health) / max_health) * 100.0  # convert to percentage

func die():
	print("Boss defeated!")
	queue_free()
	get_tree().change_scene_to_file("res://scenes/endscreen.tscn")
func enable_damage():
	can_take_damage = true  # Allow taking damage again
