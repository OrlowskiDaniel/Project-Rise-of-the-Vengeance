extends CharacterBody2D
@export var speed: float = 100.0  # Movement speed
@export var teleport_range: float = 300.0  # Maximum teleport distance
@export var projectile_scene: PackedScene  # Projectile scene
@export var minion_scene: PackedScene  # Minion scene
@export var min_x: float = 100.0  # Left boundary
@export var max_x: float = 900.0  # Right boundary
@export var min_y: float = 100.0  # Top boundary
@export var max_y: float = 600.0  # Bottom boundary


@onready var move_timer: Timer = $MoveTimer
@onready var teleport_timer: Timer = $TeleportTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var summon_timer: Timer = $SummonTimer

var direction: Vector2 = Vector2.ZERO

func _ready():
	move_timer.timeout.connect(change_direction)
	teleport_timer.timeout.connect(teleport)
	attack_timer.timeout.connect(shoot_projectile)
	summon_timer.timeout.connect(summon_minion)

	move_timer.start(1.5)  # Change direction every 1.5 seconds
	teleport_timer.start(5.0)  # Teleport every 5 seconds
	attack_timer.start(2.0)  # Shoot every 2 seconds
	summon_timer.start(7.0)  # Summon minion every 7 seconds

func _process(delta):
	position += direction * speed * delta  # Move in the random direction

func change_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func teleport():
	var new_position: Vector2
	var max_attempts = 10  # Try up to 10 times to find a safe spot

	for i in range(max_attempts):
		# Generate a random position within the map boundaries
		new_position = global_position + Vector2(randf_range(-teleport_range, teleport_range), randf_range(-teleport_range, teleport_range))

		# Clamp to stay inside the map boundaries
		new_position.x = clamp(new_position.x, min_x, max_x)
		new_position.y = clamp(new_position.y, min_y, max_y)

		# Check if the position is free of collisions
		if not is_position_colliding(new_position):
			global_position = new_position  # Move to safe position
			return  # Exit function if a valid position is found

	print("No valid teleport position found!")  # Debugging

func is_position_colliding(position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_bodies = true
	query.collide_with_areas = false  # Ignore areas (e.g., damage zones)
	
	var result = space_state.intersect_point(query)
	return result.size() > 0  # If something is detected, it's a collision

func shoot_projectile():
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			projectile.direction = (player.global_position - global_position).normalized()
		get_parent().add_child(projectile)

func summon_minion():
	if minion_scene:
		var minion = minion_scene.instantiate()
		minion.global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		get_parent().add_child(minion)
