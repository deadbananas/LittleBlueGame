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
var Wipeout_end_State: State

@onready var hitbox_attack_1 = $"../../LittleBlue_sheets/attack/hitbox-attack-1"
@onready var hitbox_attack_2 = $"../../LittleBlue_sheets/attack/hitbox-attack-2"

var hit = false
var struck_big = false

func enter() -> void:
	super()
	struck_big = false
	hit = false
	
	
func process_input(event: InputEvent) -> State:
	if !get_wipeout():
		return Wipeout_end_State
	return null

func process_physics(delta: float) -> State:
	if struck_big:
		struck_big = false
		return hit_lock_state
	if hit:
		hit = false
		return hit_state
		
	#if get_jump() and parent.is_on_floor():
		#return jump_state

	parent.velocity.y += gravity * delta
		
	#var movement = get_movement_input() * move_speed
	#var flip = 1.0 
	#if movement < 0:
		#flip = -1.0
	#else:
		#flip = 1.0
	#sprite.scale.x = flip
	parent.velocity.x = 0
	parent.move_and_slide()

	return null



func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	struck_big = true
