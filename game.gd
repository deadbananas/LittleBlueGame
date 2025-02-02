extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.max_fps = 60
	#Engine.time_scale = 0.3
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CurrentFPS.text = "Current FPS: " + str(Engine.get_frames_per_second())
 
