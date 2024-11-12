extends Node

@export
var parent: CharacterBody2D

var direction := 1.0

# When a wall is touched, move in the opposite direction
func get_movement_direction() -> float:
	direction = 1000
	
	return direction

# This poor character never learned how to jump
func wants_jump() -> bool:
	return false
