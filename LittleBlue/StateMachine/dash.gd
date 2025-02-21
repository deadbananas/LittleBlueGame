extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var jump_max_state: State
@export
var attack_state: State
@export
var parry_state: State
@export
var hit_state: State
@export
var hit_lock_state: State

@export
var jump_force: float = 450.0

@export var ghost_node : PackedScene
@onready var particles = $"../../GPUParticles2D"



var hit = false
var strike_big = false

func enter() -> void:
	super()
	hit = false
	strike_big = false
	parent.velocity.y = -jump_force
	particles.emitting = true

func process_physics(delta: float) -> State:
		
	parent.velocity.y += gravity * delta
	add_ghost()
	var movement = get_movement_input() * move_speed
	
	if parent.velocity.y > 0:
		particles.emitting = false
		return jump_max_state
		
	if movement != 0:
		var flip = 1.0
		if movement < 0:
			flip = -1.0
		else:
			flip = 1.0
		sprite.scale.x = flip
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			particles.emitting = false
			return move_state
		particles.emitting = false
		return idle_state
	
	return null


func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(parent.position, parent.scale) #Call Ghost Set Property to align pos and scale
	get_tree().current_scene.add_child(ghost)
