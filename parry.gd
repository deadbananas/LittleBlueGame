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
var hit_state: State

var hit = false

var stopped = false

var is_complete := false
#var wants_follow_up := false

func enter() -> void:
	is_complete = false
	hit = false
	stopped = false
	#wants_follow_up = false
	super()
	await animations.animation_finished
	is_complete = true

func process_input(event: InputEvent) -> State:
	#if (Input.is_action_just_pressed("attack")):
		#wants_follow_up
	return null

func process_physics(delta: float) -> State:
	if hit:
		hit = false
		return hit_state
		
	if get_jump() and parent.is_on_floor():
		return jump_state

	parent.velocity.y += gravity * delta

	var movement = get_movement_input() * move_speed
	
	#var flip = 1.0
	#if movement < 0:
		#flip = -1.0
	#else:
		#flip = 1.0
	#sprite.scale.x = flip
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if is_complete:
		if movement == 0:
			return idle_state
		else:
			return move_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
	
	
func _on_hurtbox_received_hit(damage, time_scale, duration):
	if !stopped:
		hit = true
	
	
	


func _on_parry_area_entered(area: Area2D) -> void:
	stopped = true
	print("parry")
	frameFreeze(0.1, 0.4)
	if area.has_method("parried"):
		area.parried()
	

	



func _on_block_area_entered(area: Area2D) -> void:
	stopped = true
	print("blocked")


func frameFreeze(time_scale, duration):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(time_scale * duration).timeout)
	Engine.time_scale = 1.0
