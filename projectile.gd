extends CharacterBody2D

@export var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(10)  # Assuming the player has a take_damage function
		queue_free()
