extends BTAction


@export var target_var := &"target"

@export var speed_var = 800

@export var distance = 200

func _tick(_delta: float) -> Status:
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position
		var dir = agent.global_position.direction_to(target_position)
		
		
		if abs(agent.global_position.x - target_position.x) > distance:
			agent.moveAway(-dir.x, 0)
			return SUCCESS
		else:
			agent.moveAway(-dir.x, speed_var)
			return RUNNING	
	return FAILURE
