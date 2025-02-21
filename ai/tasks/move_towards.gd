extends BTAction


@export var target_var := &"target"

@export var speed_var = 800

@export var distance = 200

var target

var target_position

func _enter():
	target= blackboard.get_var(target_var)

	target_position = target.global_position
	
func _tick(_delta: float) -> Status:
	if target != null:
		
		var dir = agent.global_position.direction_to(target_position)
		
		
		if abs(agent.global_position.x - target_position.x) < distance:
			agent.move(dir.x, 0)
			return SUCCESS
		else:
			agent.move(dir.x, speed_var)
			return RUNNING	
	return FAILURE
