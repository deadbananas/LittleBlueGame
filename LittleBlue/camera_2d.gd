extends Camera2D

@export var strength = 30
@export var fade = 5

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

var called = false

func apply_shake():
	shake_strength = strength
	called = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if called:
		apply_shake()
		
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, fade * delta)
		
		offset += randomOffset()


func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func cameraShake():
	called = true
