extends State


@export
var hit_state: State
@export
var hit_lock_state: State
@export
var idle_state: State
@export
var move_state: State

@onready var hitbox_attack_1 = $"../../LittleBlue_sheets/attack/hitbox-attack-1"
@onready var hitbox_attack_2 = $"../../LittleBlue_sheets/attack/hitbox-attack-2"

var hit = false
var struck_big = false
var is_complete = false
var countered = false

func enter() -> void:
	super()
	struck_big = false
	is_complete = false
	countered = false
	hit = false
	await animations.animation_finished
	is_complete = true
	
func process_physics(delta: float) -> State:
	if hit and !countered:
		hit = false
		return hit_state
	if is_complete:
		var movement = get_movement_input()
		if movement == 0:
			return idle_state
		else:
			return move_state
	
	return null



func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	struck_big = true


func _on_area_2d_area_entered(area):
	countered = true
