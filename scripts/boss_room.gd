extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		get_tree().change_scene_to_file("res://scenes/boss_room.tscn")

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		pass
