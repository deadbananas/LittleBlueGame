extends State


@export
var shrink_run_state: State

signal time_slow
@onready var camera_2d = $"../../Camera2D"
var is_complete = false
var hit = false
var strike_big = false

func enter() -> void:
	super()
	is_complete = false
	camera_handle()
	time_slow.emit()
	await animations.animation_finished
	is_complete = true

func process_physics(delta: float) -> State:
	if is_complete:
		return shrink_run_state
	return null


func camera_handle():
	var tween = get_tree().create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(2, 2), 0.17)
	tween.tween_property(camera_2d, "offset", Vector2(0, -30), 0.17)
	print(camera_2d.zoom)
