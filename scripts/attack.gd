extends State

@export var bullet_node: PackedScene
var can_transition

func enterd():
	super.enter()
	can_transition = false
	
	animation_player.play("ranged_attack")
	await animation_player.animation_finished
	
	can_transition = true

func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = owner.position + Vector2(0, 27)
	get_tree().current_scene.add_child(bullet)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("summon")
