extends ColorRect

@onready var blue_progress = $"."
@onready var lindon_progress = $LindonProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	blue_progress.material.set_shader_parameter("progress", 0.5)
	lindon_progress.material.set_shader_parameter("progress", 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
