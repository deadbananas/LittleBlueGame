extends State

@export var idle_state: State
@export var move_state: State
@export var jump_state: State
@export var fall_state: State
@export var attack_state: State
@export var hit_state: State
@export var shrink_start_r_state: State
@export var knockback_scalar := 40
@export var shrinkValHolder: Node

@onready var hurtbox = $"../../hurtbox"

signal parrying()
signal endParrying()

var is_complete := false
var triggeringHitbox: Node = null
var knockback_applied := Vector2.ZERO
var knockback_timer := 0.0

func enter() -> void:
	super()
	parrying.emit()
	is_complete = false
	triggeringHitbox = null
	knockback_applied = Vector2.ZERO
	knockback_timer = 0.0
	animations.play(animation_name) # Start the parry animation

func process_input(event: InputEvent) -> State:
	# Player can't move or attack during parry
	return null

func process_physics(delta: float) -> State:
	# Gravity still applies
	parent.velocity.y += gravity * delta

	# If we got hit, apply knockback for a short period
	if triggeringHitbox:
		if knockback_timer > 0:
			knockback_timer -= delta
			parent.velocity = knockback_applied
			parent.move_and_slide()
			return null
		else:
			# Knockback finished — decide next state
			triggeringHitbox = null
			knockback_applied = Vector2.ZERO
			if !parent.is_on_floor():
				return fall_state
			elif get_movement_input() == 0:
				return idle_state
			else:
				return move_state
	else:
		parent.velocity.x = 0

	# If parry animation finished naturally
	if !animations.is_playing() and !triggeringHitbox:
		is_complete = true
		
	# Handle shrink transitions first
	var shrink = get_shrink()
	if shrink != 0:
		if shrink == 1.0:
			shrinkValHolder.set_shrink_side(true)
			return shrink_start_r_state
		elif shrink == 0.5:
			shrinkValHolder.set_shrink_side(false)
			return shrink_start_r_state
		
	if is_complete:
		# Jump or fall logic
		if get_jump() and parent.is_on_floor():
			return jump_state
		
		if !parent.is_on_floor():
			return fall_state
		
		# Default: idle or move
		if get_movement_input() == 0:
			return idle_state
		else:
			return move_state

	parent.move_and_slide()
	return null

func exit() -> void:
	super()
	endParrying.emit()
	knockback_applied = Vector2.ZERO
	triggeringHitbox = null

func knockbackCalc(knock_dir_mod: Vector2, knock_force: float, relative_pos: Vector2):
	var kb = knock_dir_mod * knock_force
	if relative_pos.x < 0:
		kb.x *= -1
	knockback_applied = kb

func _on_hurtbox_hitbox_holder(hitbox: Node):
	triggeringHitbox = hitbox
	var knock_dir = Vector2(hitbox.get_knockbackDirHori(), hitbox.get_knockbackDirVert())
	var rel_pos = hitbox.global_position.direction_to(hurtbox.global_position)
	knockbackCalc(knock_dir, hitbox.get_knockback() * knockback_scalar, rel_pos)
	knockback_timer = 0.2  # seconds to apply knockback
