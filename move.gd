extends State

@export
var Fist_Strike_state: State

var fist = false

func process_physics(delta: float) -> State:
	#if get_jump() and parent.is_on_floor():
		#pass
#
	#parent.velocity.y += gravity * delta
#
	#var movement = get_movement_input() * move_speed
	#
	#if movement == 0:
		#pass
	#
	#animations.flip_h = movement < 0
	#parent.velocity.x = movement
	#parent.move_and_slide()
	#                                                     
	#if !parent.is_on_floor():
		#pass              
	#return null
	if fist:
		fist = false
		return Fist_Strike_state
	return null
	
func _on_timer_timeout():
	fist = true
