extends CharacterBody2D
@export var speed: float = 100.0  # Movement speed
@export var teleport_range: float = 300.0  # Maximum teleport distance
@export var projectile_scene: PackedScene  # Projectile scene
@export var minion_scene: PackedScene  # Minion scene

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
	var new_position = global_position + Vector2(randf_range(-teleport_range, teleport_range), randf_range(-teleport_range, teleport_range))
	global_position = new_position  # Instantly move to a new random location

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
