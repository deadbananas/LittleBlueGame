extends Node

@onready var pure_layer = $PureLayer
@onready var main_character = %main_character
@onready var animation_player = $AnimationPlayer


var baseWill = 0

var curWill = 0.0

var spriteMat 

var lowerWillBound = 33

var upperWillBound = -50

var prev_will = 0
var last_lindon_will = 0

var willTimerInt = 3

var interval = false

var slow = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.max_fps = 60
	Engine.time_scale = 1
	
	curWill = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Slow"):
		slow = !slow
	if slow:
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1
	$CurrentFPS.text = "Current FPS: " + str(Engine.get_frames_per_second())
	pure_layer.position.y = curWill
	if !interval:
		var willTimer : Timer = Timer.new()
		add_child(willTimer)
		willTimer.one_shot = true
		willTimer.autostart = true
		willTimer.wait_time = willTimerInt
		willTimer.timeout.connect(will_timeout)
		willTimer.start()
		last_lindon_will = prev_will
		interval = true

func will_timeout():
	if prev_will == last_lindon_will:
		curWill = curWill + 1.5
		willTimerInt = 0.5
	else:
		willTimerInt = 3
	var intTimer : Timer = Timer.new()
	add_child(intTimer)
	intTimer.one_shot = true
	intTimer.autostart = true
	intTimer.wait_time = willTimerInt
	intTimer.timeout.connect(interval_reset)
	intTimer.start()
		
func _on_lindon_will_change(will):
	curWill = curWill + will
	prev_will = curWill


func _on_main_character_will_change(will):
	curWill = curWill + will

func interval_reset():
	interval = false
