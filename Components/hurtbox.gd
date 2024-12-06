class_name HurtBox
extends Area2D



signal received_hit(damage: int, time_scale: int, duration: int)

#@export var health: Health

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)


func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox != null:
		frameFreeze(hitbox.time_scale, hitbox.duration)
		received_hit.emit(hitbox.damage, hitbox.time_scale, hitbox.duration)
		
func frameFreeze(time_scale, duration):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(time_scale * duration).timeout)
	Engine.time_scale = 1.0
