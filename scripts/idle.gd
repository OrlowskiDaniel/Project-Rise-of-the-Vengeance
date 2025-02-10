extends State

@onready var collision = %CollisionShape2D
@onready var progress_bar = %ProgressBar

var player_enterd: bool = false:
	set(value):
		player_enterd = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)

func _on_player_entered(_body: Node2D) -> void:
	player_enterd = true

func transition():
	if player_enterd:
		get_parent().change_state("summon")
