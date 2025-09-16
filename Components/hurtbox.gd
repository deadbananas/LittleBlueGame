class_name HurtBox
extends Area2D
@onready var parry_sound = $"../parrySound"



signal received_hit(damage: int, time_scale: float, duration: float)

signal hitbox_holder(hitbox: Hitbox)


signal received_knockback(knockback_applied: Vector2)

signal hitstun_end()


@export var hitable = true
@export var parried = false
@export var countered = false

var stopped = false

var monitor = false

@export var hit_immunity = 0.7

#@export var health: Health

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox: HitBox) -> void:

	if hitbox != null:
		if hitable and !parried and !countered:
			received_hit.emit(hitbox.damage, hitbox.time_scale, hitbox.duration)
			hitbox_holder.emit(hitbox)
			if hit_immunity != 0:
				var hitTimer : Timer = Timer.new()
				add_child(hitTimer)
				hitTimer.one_shot = true
				hitTimer.autostart = true
				hitTimer.wait_time = hit_immunity
				hitTimer.timeout.connect(timer_timeout)
				hitTimer.start()
				hitable = false
			
			

		
func _on_parry_area_entered(area: Area2D) -> void:
	stopped = true
	#frameFreeze(0.1, 0.4)
	if area.has_method("parried") and monitor:
		area.parried()
		parry_sound.play()
		hitbox_holder.emit(area)
		var parryTimer : Timer = Timer.new()
		add_child(parryTimer)
		parryTimer.one_shot = true
		parryTimer.autostart = true
		parryTimer.wait_time = 0.7
		parryTimer.timeout.connect(parryTimer_timer_timeout)
		parryTimer.start()
		hitable = false
		parried = true
		monitor = false

	
func parryTimer_timer_timeout():
	hitable = true
	parried = false
	countered = false


func _on_block_area_entered(area: Area2D) -> void:
	stopped = true
	if monitor:
		pass

func timer_timeout():
	hitable = true
	hitstun_end.emit()


func _on_parry_parrying():
	monitor = true


func _on_parry_end_parrying():
	monitor = false


func _on_countered_enter_area_entered(area):
	stopped = true
	#frameFreeze(0.1, 0.4)
	if area.has_method("countered"):
		area.countered()
		hitbox_holder.emit(area)
		var counterTimer : Timer = Timer.new()
		add_child(counterTimer)
		counterTimer.one_shot = true
		counterTimer.autostart = true
		counterTimer.wait_time = 0.7
		counterTimer.timeout.connect(parryTimer_timer_timeout)
		counterTimer.start()
		hitable = false
		countered = true
		monitor = false
