class_name HurtBox
extends Area2D



signal received_hit(damage: int, time_scale: float, duration: float)


signal received_knockback(knockback_applied: Vector2)

signal hitstun_end()


var hitable = true

@export var hit_immunity = 0.7

#@export var health: Health

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null:
		if hitable:
			var knock_dir = Vector2(hitbox.knockbackDirHori, hitbox.knockbackDirVert)
			var rel_pos =hitbox.global_position.direction_to(self.global_position)
			knockback(knock_dir, hitbox.knockback, rel_pos)
			received_hit.emit(hitbox.damage, hitbox.time_scale, hitbox.duration)
			frameFreeze(hitbox.time_scale, hitbox.duration)
			var hitTimer : Timer = Timer.new()
			add_child(hitTimer)
			hitTimer.one_shot = true
			hitTimer.autostart = true
			hitTimer.wait_time = hit_immunity
			hitTimer.timeout.connect(timer_timeout)
			hitTimer.start()
			hitable = false
			
			

		
func frameFreeze(time_scale, duration):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(time_scale * duration).timeout)
	Engine.time_scale = 1.0

func timer_timeout():
	hitable = true
	hitstun_end.emit()


func knockback(knock_dir_mod: Vector2, knock_force: float, relative_pos: Vector2):
	if relative_pos.x >= 0:
		var knockback_applied = knock_dir_mod * knock_force
		received_knockback.emit(knockback_applied)
	
	else:
		var knockback_applied = knock_dir_mod * knock_force
		knockback_applied.x = knockback_applied.x * -1
		received_knockback.emit(knockback_applied)
	
