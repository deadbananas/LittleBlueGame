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

var knockback
var is_complete := false
var spriteMat


var totalHealth = 60
var health = 10

func enter() -> void:
	super()
	is_complete = false
	spriteMat = sprite.get_node("jump_up")
	flash()

func process_physics(delta: float) -> State:
	parent.velocity += knockback
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


func _on_hurtbox_received_knockback(knockback_applied):
	knockback = knockback_applied


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
