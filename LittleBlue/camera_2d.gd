extends Camera2D
@onready var camera_2d = $"."

@export var strength = 15
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
		var shakeTimer : Timer = Timer.new()
		add_child(shakeTimer)
		shakeTimer.one_shot = true
		shakeTimer.autostart = true
		shakeTimer.wait_time = 0.7
		shakeTimer.timeout.connect(resetShake)
		shakeTimer.start()
		
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, fade * delta)
		
		offset += randomOffset()
		

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func cameraShake():
	called = true


func resetShake():
	var tween = get_tree().create_tween()
	tween.tween_property(camera_2d, "camera_2d.offset", Vector2(0, -75), 1)
	shake_strength = 0
