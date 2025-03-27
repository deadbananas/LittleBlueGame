extends State


@export
var idle_state: State
@export
var move_state: State

var is_complete = false

func enter() -> void:
	super()
	parent.position = parent.position + Vector2(0, -5)
	is_complete = false
	await animations.animation_finished
	is_complete = true

func process_physics(delta: float) -> State:
	if is_complete:
		var movement = get_movement_input()
		if movement == 0:
			return idle_state
		else:
			return move_state

	return null
