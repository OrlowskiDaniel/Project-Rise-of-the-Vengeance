extends Node2D

var current_state: State
var previous_state: State

func _ready():
	if get_child_count() > 0 and get_child(0) is State:
		current_state = get_child(0) as State
		previous_state = current_state
		current_state.enter()
	else:
		print("Error: Initial state not found or invalid.")

func change_state(state):
	if state == previous_state.name:
		return

	var new_state = find_child(state)
	if not new_state or not (new_state is State):
		print("Error: Couldn't find or switch to state '%s'" % state)
		return

	previous_state.exit()
	current_state = new_state
	current_state.enter()
	previous_state = current_state
