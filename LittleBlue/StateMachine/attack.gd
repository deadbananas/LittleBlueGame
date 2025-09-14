extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var fall_state: State
@export
var attack2_state: State
@export
var parry_state: State
@export
var hit_state: State
@export
var dash_state: State

var is_complete := false
var wants_follow_up := false

var attack2_wait_time := 0.05
var attack2_time_remain := 0.0


var hit = false


func enter() -> void:
	is_complete = false
	hit = false
	wants_follow_up = false
	attack2_time_remain = attack2_wait_time
	super()
	await animations.animation_finished
	is_complete = true

func process_input(event: InputEvent) -> State:
	if (Input.is_action_just_pressed("attack")):
		if attack2_time_remain < 0:
			wants_follow_up = true
	if (Input.is_action_just_pressed("dash")) and canDash():
		return dash_state
	if (Input.is_action_just_pressed("parry_right")):
		return parry_state
	return null

func process_physics(delta: float) -> State:
	if hit:
		hit = false
		return hit_state
	if get_jump() and parent.is_on_floor():
		return jump_state

	parent.velocity.y += gravity * delta
	attack2_time_remain -= delta
	var movement = get_movement_input() * move_speed
	
	#var flip = 1.0
	#if movement < 0:
		#flip = -1.0
	#else:
		#flip = 1.0
	#sprite.scale.x = flip
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if is_complete:
		if wants_follow_up:
			return attack2_state
		elif movement == 0:
			return idle_state
		else:
			return move_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
	
	
func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true
