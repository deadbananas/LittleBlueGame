
extends BTAction


@export var target_var := &"target"

@export var speed_var = 60

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
		if dir.x < 0:
			side = (agent.global_position.x - target_position.x) < -1 * distance
		else:
			side = (agent.global_position.x - target_position.x) > distance
		if side:
			agent.basic_combo_end_dash(dir.x, 0)
			start = 0
			return SUCCESS
		else:
			agent.basic_combo_end_dash(dir.x, speed_var)
			return RUNNING		
	return FAILURE
