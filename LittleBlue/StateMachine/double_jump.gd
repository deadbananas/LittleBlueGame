extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_max_state: State
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
var jump_force: float = 600.0

var hit = false
var strike_big = false

func enter() -> void:
	super()
	parent.velocity.y = -jump_force
	hit = false
	strike_big = false
	
func process_input(event: InputEvent) -> State:
	if (Input.is_action_just_pressed("dash")):
		return dash_state
	return null


func process_physics(delta: float) -> State:
	if strike_big:
		return hit_lock_state
	if hit:
		hit = false
		return hit_state
	

	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return jump_max_state
	
	var movement = get_movement_input() * move_speed
	
	if movement != 0:
		var flip = 1.0
		if movement < 0:
			flip = -1.0
		else:
			flip = 1.0
		sprite.scale.x = flip
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null


func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	strike_big = true
