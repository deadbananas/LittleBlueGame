extends State


@export
var shrink_run_state: State



var is_complete = false
var hit = false
var strike_big = false

func enter() -> void:
	super()
	await animations.animation_finished
	is_complete = true

func process_physics(delta: float) -> State:
	if is_complete:
		return shrink_run_state
	return null


func exit() -> void:
	super()
	parent.position.x = parent.position.x + 30
	parent.position.y = parent.position.y + 8.5
