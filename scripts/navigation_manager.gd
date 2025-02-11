extends Node

const scene_bridge = preload("res://scenes/bridge.tscn")
const scene_boss_room = preload("res://scenes/boss_room.tscn")

var spawn_door_tag

func go_to_level(level_tag, destenation_tag):
	var scene_to_load
	
	match level_tag:
		"bridge":
			scene_to_load = scene_boss_room
		"boss_room":
			scene_to_load = scene_bridge
			
	if scene_to_load != null:
		spawn_door_tag = destenation_tag
		get_tree().change_scene_to_packed(scene_to_load)
	
