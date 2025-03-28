extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var fall_state: State
@export
var attack_state: State
@export
var parry_state: State


@export var knockback_scalar = 40


var is_complete := false
var spriteMat

var willDiff = 5.0
signal will_change(willDiff)

var totalHealth = 60
var health = 10
var knockback_applied = 0

var triggeringHitbox

func enter() -> void:
	super()
	is_complete = false
	spriteMat = sprite.get_node("jump_up")
	will_change.emit(willDiff)
	var knock_dir = Vector2(triggeringHitbox.knockbackDirHori, triggeringHitbox.knockbackDirVert)
	var rel_pos = triggeringHitbox.global_position.direction_to(parent.global_position)
	frameFreeze(triggeringHitbox.time_scale, triggeringHitbox.duration)
	knockback(knock_dir, triggeringHitbox.knockback * knockback_scalar, rel_pos)
	flash()

func process_physics(delta: float) -> State:
	parent.velocity = knockback_applied
	parent.move_and_slide()
	
	if health <= 0:
		queue_free()
	
	#print(parent.velocity)
	if is_complete:
		if !parent.is_on_floor():
			return fall_state
		elif parent.velocity.x == 0:
			return idle_state
		else:
			return move_state
			
	return null

	


func _on_hurtbox_hitstun_end():
	is_complete = true



func flash():
	spriteMat.material.set_shader_parameter("flash_mod", 0.86)
	var flashTimer : Timer = Timer.new()
	add_child(flashTimer)
	flashTimer.one_shot = true
	flashTimer.autostart = true
	flashTimer.wait_time = 0.7
	flashTimer.timeout.connect(timer_timeout)
	flashTimer.start()


func timer_timeout():
	spriteMat.material.set_shader_parameter("flash_mod", 0.0)
	
func knockback(knock_dir_mod: Vector2, knock_force: float, relative_pos: Vector2):
	if relative_pos.x >= 0:
		knockback_applied = knock_dir_mod * knock_force
	
	else:
		knockback_applied = knock_dir_mod * knock_force
		knockback_applied.x = knockback_applied.x * -1
	
func frameFreeze(time_scale, duration):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(time_scale * duration).timeout)
	Engine.time_scale = 1.0


func _on_hurtbox_hitbox_holder(hitbox):
	triggeringHitbox = hitbox
	
