extends CharacterBody2D

@export var speed: float = 75.0
var target

func _ready():
	target = get_tree().get_first_node_in_group("Player")

func _process(delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta
