extends BTAction


@export var target_var := &"target"

@export var speed_var = 400

@export var hori_tolerance = 60

@export var vert_tolerance = 10


func _tick(_delta: float) -> Status:
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position
		var x_val
		if agent.global_position.x - target_position.x > 0:
			x_val = 50
		else:
			x_val = -50
		target_position.x = target_position.x + x_val
		target_position = Vector2(target_position.x, target_position.y)
		var dir = agent.global_position.direction_to(target_position)
		var dirRaw = agent.global_position.direction_to(Vector2(target_position.x - x_val, target_position.y))
		if abs(agent.global_position.x - target_position.x) < hori_tolerance:
			if abs((target_position.y + 10) - agent.global_position.y) < vert_tolerance:
				agent.descend(dir, 0, dirRaw.x)
				return SUCCESS
			else:
				return RUNNING
		else:
			agent.descend(dir, speed_var, dirRaw.x)
			return RUNNING	
	return FAILURE
