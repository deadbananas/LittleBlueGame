extends State

@export
var move_state: State


var player = null
var play = 0
var slow_down = 0.07
var speed = 10000
var attack_accel = 1
var attack_move_speed = 10
var player_in_range = false

#attack velocities
var fist_strike_move_direction = 0 #0 for left, 1 for right
var fist_strike_move = false
var zero_y := Vector2(attack_move_speed,0)
var attacking = false

var done = false

@onready var fiststrikebc = $"../../fiststrikebc"

func enter() -> void:
	super()
	player = get_node("../../%main_character")
	
func process_physics(delta: float) -> State:
	if get_jump() and parent.is_on_floor():
		pass

	parent.velocity.y += gravity * delta

	var movement = get_movement_input() * move_speed
	
	if movement == 0:
		pass
	if player != null and !attacking:
		if (parent.position.x + 70 < player.position.x):
			fiststrikebc.scale.x  = -1.0
		else:
			fiststrikebc.scale.x  = 1.0
	if fist_strike_move:
		attack_accel = attack_accel + (100 * delta)
		if fist_strike_move_direction:
			var goal = Vector2(parent.position.x + 1500 ,0)
			parent.velocity = parent.velocity.lerp(-1 * goal, attack_accel * delta)

		else:
			var goal = Vector2(parent.position.x + 1500 ,0)
			parent.velocity = parent.velocity.lerp(goal,  attack_accel * delta)
	parent.velocity.y = 0
	parent.move_and_slide()
	if done:
		done = false
		return move_state
	
	if !parent.is_on_floor():
		pass
	return null
	
	
func _on_area_2d_body_entered(_body):
	player_in_range = true 
func fistStrikeBc():
	attacking = true
	var curPos = parent.position
	var curX = curPos.x + 70
	var playerCurPos = player.position
	#if !(abs(curX - playerCurPos.x) < 50):
	fist_strike_move = true
	if curX - playerCurPos.x > 0:
		fist_strike_move_direction = 1
	else:
		fist_strike_move_direction = 0
			
func zero_fist_Strike():
	fist_strike_move = false
	parent.velocity.x = 0
	parent.velocity.y = 0
	attack_accel = 1

func attacking_off():
	attacking = false
	
func doneCheck():
	done = true
