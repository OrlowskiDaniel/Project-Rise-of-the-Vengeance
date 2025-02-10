extends State

@export var summoned_enemy: PackedScene
var can_transition : bool

func enter():
	super.enter()
	can_transition = false
	
	animation_player.play("summon")
	await animation_player.animation_finished
	
	can_transition = true

func spawn():
	var enemy = summoned_enemy.instantiate()
	
	enemy.pasition = global_position + Vector2(40, 40)
	
	get_tree().current_scene.call_deferred("add child", enemy)

func transition():
	if can_transition:
		get_parent().change_state("attack")
