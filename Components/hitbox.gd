class_name HitBox
extends Area2D


@export var damage: int = 1 : set = set_damage, get = get_damage
@export var time_scale: int = 0.05 : set = set_time_scale, get = get_time_scale
@export var duration: int = 0.4 : set = set_duration, get = get_duration


func set_damage(value: int):
	damage = value
	
func get_damage() ->int:
	return damage


func set_time_scale(value: int):
	time_scale = value

func get_time_scale() ->int:
	return time_scale


func set_duration(value : int):
	duration = value
	
func get_duration() -> int:
	return duration
