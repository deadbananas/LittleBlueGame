class_name State
extends Node

@export
var animation_name: String
@export
var move_speed: float = 300
@export
var sprite_associated: Sprite2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var animations: AnimationPlayer
var move_component
var parent: CharacterBody2D

var sprite: Sprite2D

func enter() -> void:
	animations.play(animation_name)
	sprite_associated.visible = true

func exit() -> void:
	sprite_associated.visible = false

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func get_movement_input() -> float:
	return move_component.get_movement_direction()

func get_jump() -> bool:
	return move_component.wants_jump()
	
func get_shrink() -> float:
	return move_component.wants_shrink()
	
func get_small() -> bool:
	return move_component.wants_small()
	
func get_wipeout() -> bool:
	return move_component.wants_wipeout()
