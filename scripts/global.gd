extends Node

var player_current_attack = false

var current_scene = "world"
var trasition_scene = false

var player_exit_bridge_posx = 1143
var player_exit_bridge_posy = 323
var player_start_posx = 583
var player_start_posy = 507

var game_fisrt_loadin = true

func finish_changescenes():
	if trasition_scene == true:
		trasition_scene = false
		if current_scene == "world":
			current_scene = "bridge"
		else:
			current_scene = "world"
