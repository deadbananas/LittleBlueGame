extends BTAction

@export var group: StringName = "Little_Blue"

@export var target_var: StringName = &"target" 

var target

func _tick(_delta: float) -> Status:
	if group == "Little_Blue":
		target = get_little_blue_node()
	blackboard.set_var(target_var, target)
	return SUCCESS
	
func get_little_blue_node():
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	return nodes[0]
