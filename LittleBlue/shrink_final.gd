extends State


@export
var idle_state: State
@export
var move_state: State

var is_complete = false
@onready var camera_2d = $"../../Camera2D"

func enter() -> void:
	super()
	is_complete = false
	animations.speed_scale = 1
	parent.scale = Vector2(1, 1)
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

func exit() -> void:
	super()
	parent.position = parent.position + Vector2(50, 0)
	camera_2d.zoom = Vector2(1,1)
