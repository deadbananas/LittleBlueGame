extends State


@export
var shrink_finale_state: State

@onready var camera_2d = $"../../Camera2D"

@export var shrinkValHolder: Node
@onready var hurtbox = $"../../hurtbox"

var is_complete = false
var hit = false
var strike_big = false
var reached = false
var velocitySet = 0

func enter() -> void:
	super()
	is_complete = false
	var shrink_r = shrinkValHolder.get_shrink_side()
	if shrink_r:
		velocitySet = 200
	else:
		velocitySet = -200
	hurtbox.hitable = false
	await animations.animation_finished
	is_complete = true
	
	

func process_physics(delta: float) -> State:
	animations.speed_scale = 5
	parent.scale = Vector2(0.5, 0.5)
	if is_complete:
		return shrink_finale_state
	parent.velocity.x = velocitySet
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
 
func _on_little_blue_shrink_pass():
	is_complete = true
