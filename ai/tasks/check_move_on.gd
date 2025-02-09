extends BTAction


func _tick(_delta: float) -> Status:
	var value = agent.get_move_on()
	if value == true:
		return SUCCESS
	else:
		return FAILURE
	
