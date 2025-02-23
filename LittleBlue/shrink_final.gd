extends State


@export
var idle_state: State


var hit = false
var strike_big = false

func enter() -> void:
	super()
	animations.speed_scale = 1
	parent.scale = Vector2(1, 1)

func process_physics(delta: float) -> State:
	
	return null


func reset_move():
	parent.position.x = parent.position.x - 30
	parent.position.y = parent.position.y - 8.5
