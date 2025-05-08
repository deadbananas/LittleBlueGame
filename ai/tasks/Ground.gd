extends BTAction


@export var target_var := &"target"

@export var speed_var = 100



func _tick(_delta: float) -> Status:
	var goal_pos = Vector2(agent.global_position.x, -13)
	var dir = agent.global_position.direction_to(goal_pos)
	if agent.global_position.y > goal_pos.y:
		agent.descend(dir, 0)
		return SUCCESS
	else:
		agent.descend(dir, speed_var)
		return RUNNING	
	return FAILURE
