extends BTAction


@export var target_var := &"target"

@export var target_dif: StringName = &"target_dif"

func _tick(_delta: float) -> Status:
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position
		var dir = agent.global_position.direction_to(target_position)
		var dif = abs(agent.global_position.x - target_position.x)
		blackboard.set_var(target_dif, dif)
		return SUCCESS
	return FAILURE
