extends State

@export
var small_state: State
@export
var fall_state: State
@export
var hit_state: State
@export
var hit_lock_state: State


var is_complete = false
var hit = false
var struck_big = false

func enter() -> void:
	super()
	is_complete = false
	hit = false
	struck_big = false
	await animations.animation_finished
	is_complete = true

func process_physics(delta: float) -> State:
	if struck_big:
		struck_big = false
		return hit_lock_state
	if hit:
		hit = false
		return hit_state
		
	if is_complete:
		return small_state
		
	
	if !parent.is_on_floor():
		return fall_state
	return null



func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	struck_big = true
