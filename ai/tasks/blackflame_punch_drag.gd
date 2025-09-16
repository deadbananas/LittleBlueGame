#
#extends BTAction
#
#
#@export var target_var := &"target"
#
#@export var speed_var = 600
#
#
#@export var distance = 60
#
#@export var follow_distance = 15
#
#@export var tolerance = 40
#
#var start = 0
#
#var dir = 0
#var cur_dir = 0
#var side
#var cont
#var one_more_hit = 0.28
#var time = 0
#var cont_lock = false
#func _tick(_delta: float) -> Status:
	#var target: CharacterBody2D = blackboard.get_var(target_var)
	#if target != null:
		#var target_position = target.global_position		
		#if start == 0:
			#dir = agent.global_position.direction_to(target_position)
		#start = 1
		#cur_dir = agent.global_position.direction_to(target_position)
		#if dir.x < 0:
			#side = (agent.global_position.x - target_position.x) < -1 * distance
			#if !cont_lock:
				#cont = abs((agent.global_position.x - target_position.x)) < 10
		#else:
			#side = (agent.global_position.x - target_position.x) > distance
			#if !cont_lock:
				#cont = abs((agent.global_position.x - target_position.x)) < 10
		#if side && !cont:
			#agent.basic_combo_end_dash(dir.x, 0)
			#start = 0
			#return SUCCESS
		#elif cont:
			#cont_lock = true
			#if one_more_hit < time:
				#agent.basic_combo_end_dash(dir.x, 0)
				#start = 0
				#cont = false
				#cont_lock = false
				#time = 0
				#return SUCCESS
			#else:
				#time += _delta
				#agent.basic_combo_end_dash(dir.x, speed_var)
				#return RUNNING
		#else:
			#agent.basic_combo_end_dash(dir.x, speed_var)
			#return RUNNING		
	#return FAILURE


extends BTAction


@export var target_var := &"target"

@export var speed_var = 600

@export var distance = 60

@export var tolerance = 40

var start = 0

var dir = 0
var cur_dir = 0
var side
func _tick(_delta: float) -> Status:
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position		
		if start == 0:
			dir = agent.global_position.direction_to(target_position)
		start = 1
		cur_dir = agent.global_position.direction_to(target_position)
		side = agent.get_fist_check_area_entered()
		if side:
			agent.basic_combo_end_dash(dir.x, 0)
			start = 0
			return SUCCESS
		else:
			agent.basic_combo_end_dash(dir.x, speed_var)
			return RUNNING		
	print("failed")
	return FAILURE
