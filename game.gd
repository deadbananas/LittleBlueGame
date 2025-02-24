extends Node

@onready var pure_layer = $PureLayer
@onready var main_character = %main_character
@onready var animation_player = $AnimationPlayer


var baseWill = 0

var curWill = 0.0

var spriteMat 

var lowerWillBound = 33

var upperWillBound = -50
# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.max_fps = 60
	#Engine.time_scale = 0.1

	curWill = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CurrentFPS.text = "Current FPS: " + str(Engine.get_frames_per_second())
	pure_layer.position.y = curWill
	#Engine.time_scale = 0.1


func _on_lindon_will_change(will):
	var prev_will = curWill
	curWill = curWill + will


func _on_main_character_will_change(will):
	curWill = curWill + will
