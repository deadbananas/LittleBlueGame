extends State

@export
var idle_state: State
@export
var move_state: State
@export
var fall_state: State
@export
var attack_state: State
@export
var hit_state: State

var hit = false



var is_complete := false
#var wants_follow_up := false

func enter() -> void:
	is_complete = false
	hit = false
	super()
	await animations.animation_finished
	is_complete = true

func process_input(event: InputEvent) -> State:
	#if (Input.is_action_just_pressed("attack")):
		#wants_follow_up 
	return null

func process_physics(delta: float) -> State:
	if hit:
		hit = false
		return hit_state
		

	parent.velocity.y += gravity * delta

	var movement = get_movement_input() * move_speed
	
	if is_complete:
		if movement == 0:
			return idle_state
		else:
			return move_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
