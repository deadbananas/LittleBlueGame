extends State


@export
var move_state: State
@export
var jump_state: State
@export
var fall_state: State
@export
var attack_state: State
@export
var parry_state: State
@export
var hit_state: State
@export
var hit_lock_state: State
@export
var dash_state: State
@export
var small_enter_state: State

var strike_big = false
var hit = false

func enter() -> void:
	super()
	parent.velocity.x = 0
	hit = false
	strike_big = false
	
func process_input(event: InputEvent) -> State:
	if get_jump() and parent.is_on_floor():
		return jump_state
	if get_movement_input() != 0.0:
		return move_state
	if (Input.is_action_just_pressed("attack")):
		return attack_state
	if (Input.is_action_just_pressed("parry_right")):
		return parry_state
	if (Input.is_action_just_pressed("dash")):
		print("dash")
		return dash_state
	if get_small():
		return small_enter_state
	return null

func process_physics(delta: float) -> State:
	if strike_big:
		return hit_lock_state
	if hit:
		hit = false
		return hit_state
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null


func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	strike_big = true
