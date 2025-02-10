extends State

func enter():
	super.enter()
	animation_player.play("attack")

func transition():
	if owner.direction.leangth() > 40:
		get_parent().change_state("follow")
