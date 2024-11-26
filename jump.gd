extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var jump_max_state: State
@export
var attack_state: State
@export
var parry_state: State

@export
var jump_force: float = 700.0

func enter() -> void:
	super()
	parent.velocity.y = -jump_force

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return jump_max_state
	
	var movement = get_movement_input() * move_speed
	
	if movement != 0:
		animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
