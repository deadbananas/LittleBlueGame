extends Node

# Return the desired direction of movement for the character
# in the range [-1, 1], where positive values indicate a desire
# to move to the right and negative values to the left.
func get_movement_direction() -> float:
	
	return Input.get_axis('left', 'right')

# Return a boolean indicating if the character wants to jumps
func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')
