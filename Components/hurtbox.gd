class_name HurtBox
extends Area2D



signal received_hit(damage: int, time_scale: float, duration: float)


var hitable = true

@export var hit_immunity = 0.7

#@export var health: Health

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox: HitBox) -> void:
	print("on cooldown")
	if hitbox != null:
		if hitable:
			print("hit")
			frameFreeze(hitbox.time_scale, hitbox.duration)
			received_hit.emit(hitbox.damage, hitbox.time_scale, hitbox.duration)
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
