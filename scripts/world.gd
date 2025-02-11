extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.game_fisrt_loadin == true:
		$Player.position.x = global.player_start_posx
		$Player.position.y = global.player_start_posy
	else:
		$Player.position.x = global.player_exit_bridge_posx
		$Player.position.y = global.player_exit_bridge_posy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	change_scene()


func _on_brige_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.trasition_scene = true


func _on_brige_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.trasition_scene = false
		
func change_scene():
	if global.trasition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/bridge.tscn")
			global.game_fisrt_loadin = false
			global.finish_changescenes()
