extends Node

@onready var little_blue = $".."
@onready var area_2d = $"../Area2D"

var parry_wait = false
var shrink = 0.0
var lindon 
var area11 : Area2D
var inArea = false

#get direction to Lindon
func get_lindon():
	var nodes = get_tree().get_nodes_in_group("Lindon")
	if len(nodes) > 0:
		lindon = nodes[0]
	push_error("Lindon is missing...")
	
#Helper to check if parry has been pressed in a recent amount of time
func parry_pressed():
	if Input.is_action_just_pressed('parry_right') or Input.is_action_pressed('parry_right'):
		parry_wait = true
		var parryTimer : Timer = Timer.new()
		add_child(parryTimer)
		parryTimer.one_shot = true
		parryTimer.autostart = true
		parryTimer.wait_time = 0.25
		parryTimer.timeout.connect(parry_pressed_timer_timeout)
		parryTimer.start()
	
func parry_pressed_timer_timeout():	
	parry_wait = false
	
#helper function for if shrink is pressed	
func shrink_pressed():
	var pure_bf = Input.get_axis("shrink_left", "shrink_right")
	if pure_bf == 0:
		return 0
	get_lindon()
	var dir = little_blue.global_position.direction_to(lindon.global_position)
	if dir.x > 0:
		if pure_bf > 0:
			shrink = 1.0
		elif pure_bf < 0:
			shrink = -1.0
	elif dir.x < 0:
		if pure_bf > 0:
			shrink = -0.5
		elif pure_bf < 0:
			shrink = 0.5
	if shrink != 0:
		var shrinkTimer : Timer = Timer.new()
		add_child(shrinkTimer)
		shrinkTimer.one_shot = true
		shrinkTimer.autostart = true
		shrinkTimer.wait_time = 0.25
		shrinkTimer.timeout.connect(shrink_pressed_timer_timeout)
		shrinkTimer.start()
	
func shrink_pressed_timer_timeout():
	shrink = 0.0
	
# Return the desired direction of movement for the character
# in the range [-1, 1], where positive values indicate a desire
# to move to the right and negative values to the left.
func get_movement_direction() -> float:
	
	return Input.get_axis('left', 'right')

# Return a boolean indicating if the character wants to jump
func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')

# Return a float where -1 = pure right, -0.5 = pure left, 0.5 = bf left 1 = bf right
func wants_shrink() -> float:
	var shrink_manager = 0.0
	if shrink != 0 and parry_wait and inArea:
		shrink_manager = shrink
	return shrink_manager


func _on_area_2d_area_entered(area):
	area11 = area
	inArea = true
	

func _on_area_2d_area_exited(area):
	if area == area11:
		inArea = false
