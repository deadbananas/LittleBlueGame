extends State

@export
var idle_state: State
@export
var move_state: State
@export
var double_jump_state: State
@export
var hit_state: State
@export
var dash_state: State


var hit = false

func enter() -> void:
	super()
	hit = false


func process_input(event: InputEvent) -> State:
	if (Input.is_action_just_pressed("dash")):
		return dash_state
	return null


func process_physics(delta: float) -> State:
	if hit:
		hit = false
		return hit_state
		
	if get_jump() and !parent.double_jumped:
		parent.double_jumped = true
		return double_jump_state
		
	parent.velocity.y += gravity * delta
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
