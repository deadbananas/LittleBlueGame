extends State


@export
var shrink_finale_state: State



var is_complete = false
var hit = false
var strike_big = false
var reached = false

func enter() -> void:
	super()
	await animations.animation_finished
	is_complete = true
	

func process_physics(delta: float) -> State:
	animations.speed_scale = 5
	parent.scale = Vector2(0.5, 0.5)
	if is_complete:
		return shrink_finale_state
	parent.velocity.x = 400
	parent.move_and_slide()
	return null

func _on_little_blue_shrink_pass():
	print("we doin it")
	is_complete = true
