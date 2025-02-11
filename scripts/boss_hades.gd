extends CharacterBody2D

@onready var player = get_parent().get_node_or_null("player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $ProgressBar

var direction: Vector2
var health = 100:

	set(value):
		if value < health:
			health = max(value, 0)  # Ensure health doesn't go below zero
			progress_bar.value = health
		if health <= 0:
			progress_bar.visible = false
			var fsm = find_child("FiniteStateMachine")
			if fsm:
				fsm.change_state("death")

func _process(_delta):
	if player:
		direction = player.position - position

		# Flip sprite based on direction
		sprite.flip_h = direction.x < 0

func take_damage():
	health -= 10
	
