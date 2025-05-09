extends BTAction


@export var target_var := &"target"

@export var speed_var = 600
var goal_pos

func _enter():
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position
		var x_val = 0
		
		if agent.global_position.x - target_position.x > 0:
			x_val = -5
		else:
			x_val = 5
		goal_pos = Vector2(agent.global_position.x + x_val, agent.global_position.y - 80)

func _tick(_delta: float) -> Status:
	var dir = agent.global_position.direction_to(goal_pos)
	if agent.global_position.y <= goal_pos.y:
		agent.descend(dir, 0, dir.x)
		return SUCCESS
	else:
		agent.descend(dir, speed_var, dir.x)
		return RUNNING	
	return FAILURE
