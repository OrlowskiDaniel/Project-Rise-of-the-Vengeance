extends Node2D

func _process(delta: float) -> void:
	change_scenes()


func _on_bridge_start_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.trasition_scene = true


func _on_bridge_start_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.trasition_scene = false

func change_scenes():
	if global.trasition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_changescenes()
		 
