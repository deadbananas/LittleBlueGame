extends State

@export
var jump_state: State
@export
var fall_state: State
@export
var hit_state: State
@export
var hit_lock_state: State
@export
var small_leave_state: State
@export
var small_state: State

@onready var hitbox_attack_1 = $"../../LittleBlue_sheets/attack/hitbox-attack-1"
@onready var hitbox_attack_2 = $"../../LittleBlue_sheets/attack/hitbox-attack-2"

var hit = false
var struck_big = false

func enter() -> void:
	super()
	struck_big = false
	hit = false
	parent.scale = Vector2(0.5, 0.5)
	
	
func process_input(event: InputEvent) -> State:
	if !get_small():
		return small_leave_state
	return null

func process_physics(delta: float) -> State:
	if struck_big:
		struck_big = false
		return hit_lock_state
	if hit:
		hit = false
		return hit_state
		
	if get_jump() and parent.is_on_floor():
		return jump_state

	parent.velocity.y += gravity * delta
		
	var movement = get_movement_input() * move_speed
	if movement != 0:
		return small_state
	parent.velocity.x = 0
	parent.move_and_slide()

	return null

func exit() -> void:
	super()
	parent.scale = Vector2(1, 1)


func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	struck_big = true
