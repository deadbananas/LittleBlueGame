extends Node

@onready var pure_layer = $PureLayer


var baseWill = 0

var curWill = 0.0


var lowerWillBound = 33

var upperWillBound = -50
# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.max_fps = 60
	#Engine.time_scale = 0.3
	curWill = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CurrentFPS.text = "Current FPS: " + str(Engine.get_frames_per_second())
	pure_layer.position.y = curWill


func _on_lindon_will_change(will):
	var prev_will = curWill
	curWill = curWill + will
	print(prev_will + curWill)


func _on_main_character_will_change(will):
	curWill = curWill + will
