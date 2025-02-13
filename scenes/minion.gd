extends CharacterBody2D

@export var speed: float = 75.0  # Normal movement speed
@export var dash_speed: float = 300.0  # Speed when dashing
@export var dash_duration: float = 0.3  # Time spent dashing
@export var health: int = 3  # Minion's health

var player: Node2D = null  # Reference to the player
var is_dashing: bool = false  # Check if dashing
var can_take_damage: bool = true  # Damage cooldown
var player_inattack_zone = false

@onready var dash_timer: Timer = $DashTimer
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var health_bar: ProgressBar = $HealthBar  

func _ready():
	player = get_tree().get_first_node_in_group("Player")  # Get player reference
	dash_timer.timeout.connect(start_dash)
	invincibility_timer.timeout.connect(enable_damage)
	dash_timer.start(randf_range(3, 6))  # Dash every 3-6 seconds
	add_to_group("Minion")
	health_bar.value = (health / 3.0) * 100 

func _physics_process(delta):
	if player and not is_dashing:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed  # Normal movement
	move_and_slide()

func start_dash():
	if player:
		is_dashing = true
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * dash_speed  # Move very fast
		await get_tree().create_timer(dash_duration).timeout  # Wait for dash duration
		is_dashing = false
		dash_timer.start(randf_range(3, 6))  # Restart dash timer

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(5)  # Call player damage function (implement in Player script)

func take_damage(amount: int):
	if can_take_damage:
		health -= amount
		update_health_bar()
		can_take_damage = false
		invincibility_timer.start(1.0)  # 1 second cooldown
		print("Minion took damage! Health:", health)

func update_health_bar():
	if health_bar:
		health_bar.value = (health / 3.0) * 100  # Convert to percentage
		if health <= 0:
			die()  # Remove minion when health reaches 0

func die():
	queue_free()  # Remove the minion from the game

func enable_damage():
	can_take_damage = true  # Allow taking damage again
