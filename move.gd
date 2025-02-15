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

var hit = false
var struck_big = false

func enter() -> void:
	super()
	hit = false
	
	
func process_input(event: InputEvent) -> State:
	#if Input.is_action_just_pressed('dash'):
		#return dash_state
	if (Input.is_action_just_pressed("attack")):
		return attack_state
	if (Input.is_action_just_pressed("parry_right")):
		return parry_state
	return null

func process_physics(delta: float) -> State:
	if hit:
		hit = false
		return hit_state
		
	if get_jump() and parent.is_on_floor():
		return jump_state
	
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
	parent.velocity.x = movement
	if struck_big:
		parent.velocity.x = 0.0
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null




func _on_hurtbox_received_hit(damage, time_scale, duration):
	hit = true


func _on_little_blue_pass_strike():
	struck_big = true
	var struckTimer : Timer = Timer.new()
	add_child(struckTimer)
	struckTimer.one_shot = true
	struckTimer.autostart = true
	struckTimer.wait_time = 1
	struckTimer.timeout.connect(timer_timeout)
	struckTimer.start()
	
func timer_timeout():
	struck_big = false
