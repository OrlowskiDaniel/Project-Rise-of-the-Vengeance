extends Node2D

@export var speed: float = 300.0
@export var damage: int = 5  # Damage to the player
var direction: Vector2 = Vector2.ZERO

func _ready():
	set_physics_process(true)
	

func _process(delta):
	if direction != Vector2.ZERO:
		rotation = direction.angle()  # Rotate spear towards movement

func _physics_process(delta):
	position += direction * speed * delta

func _on_timeout():
	queue_free()  # destroy spear after a few seconds


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage)  
		print("Spear hit player! Dealt", damage, "damage.")
		queue_free()
