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
var attack_state: State
@export
var parry_state: State

var knockback
var is_complete := false

func enter() -> void:
	super()
	is_complete = false

func process_physics(delta: float) -> State:
	parent.velocity += knockback
	parent.move_and_slide()
	#print(parent.velocity)
	if is_complete:
		if !parent.is_on_floor():
			return fall_state
		elif parent.velocity.x == 0:
			return idle_state
		else:
			return move_state
			
	return null


func _on_hurtbox_received_knockback(knockback_applied):
	knockback = knockback_applied
	print(knockback)


func _on_hurtbox_hitstun_end():
	is_complete = true
