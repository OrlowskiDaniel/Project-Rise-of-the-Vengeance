extends Area2D

var speed = 300
var direction: Vector2 = Vector2.ZERO

func _process(delta):
	if direction != Vector2.ZERO:
		rotation = direction.angle()  # rotate spear towards movement

func _physics_process(delta):
	position += direction * speed * delta
 
 
func _on_body_entered(body):
	if body.is_in_group("Minion"):
		body.take_damage(1)
		print("Hit Minion!")  # Debugging
	elif body.is_in_group("Boss"):
		body.take_damage(1)
		print("Hit Boss!")  # Debugging
 
func _on_screen_exited() -> void:
	queue_free()
