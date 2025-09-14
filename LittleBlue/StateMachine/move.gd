extends State

@export
var idle_state: State
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
var shrink_start_r_state: State
@export
var small_enter_state: State
@export
var Wipeout_start_state: State

@onready var hitbox_attack_1 = $"../../LittleBlue_sheets/attack/hitbox-attack-1"
@onready var hitbox_attack_2 = $"../../LittleBlue_sheets/attack/hitbox-attack-2"

const Timeline = preload("res://addons/time_control/timeline.gd")

@export var timeline: Timeline

@export var shrinkValHolder: Node

var hit = false
var struck_big = false

func enter() -> void:
	super()
	struck_big = false
	hit = false
	
func process_input(event: InputEvent) -> State:
	#if Input.is_action_just_pressed('dash'):
		#return dash_state
	if (Input.is_action_just_pressed("attack")):
		return attack_state
	if (Input.is_action_just_pressed("parry_right")):
		return parry_state
	if (Input.is_action_just_pressed("dash")) and canDash():
		return dash_state
	if get_small():
		return small_enter_state
	if get_wipeout():
		return Wipeout_start_state
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
		
	var shrink : float = get_shrink()
	if shrink != 0:
		if shrink == 1.0:
			shrinkValHolder.set_shrink_side(true)
			return shrink_start_r_state
		elif shrink == 0.5:
			shrinkValHolder.set_shrink_side(false)
			return shrink_start_r_state
		

	parent.velocity.y += gravity * delta
		
	var movement = get_movement_input() * move_speed
	if movement == 0:
		return idle_state
	var flip = 1.0
	if movement < 0:
		flip = -1.0
	else:
		flip = 1.0
	sprite.scale.x = flip
	#hitbox_attack_1.scale.x = flip
	#hitbox_attack_2.scale.x = flip
	parent.velocity.x = movement * timeline.time_scale

	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null




func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	struck_big = true
