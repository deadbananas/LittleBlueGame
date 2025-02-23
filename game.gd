extends Node

@onready var pure_layer = $PureLayer
@onready var main_character = %main_character
@onready var blast_wave = $Shockwaves/blastWave
@onready var animation_player = $AnimationPlayer


var baseWill = 0

var curWill = 0.0

var spriteMat 

var lowerWillBound = 33
var blasting = false
var center
var scalar
var viewport_size : Vector2
var i = 0
var container_size : Vector2

var upperWillBound = -50
# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.max_fps = 60
	Engine.time_scale = 0.3
	spriteMat = get_node("Shockwaves/blastWave")
	curWill = 0.0
	viewport_size = get_viewport().size
	container_size = blast_wave.size
	scalar = (viewport_size / container_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CurrentFPS.text = "Current FPS: " + str(Engine.get_frames_per_second())
	pure_layer.position.y = curWill
	if !blasting:
		center = main_character.position
		center = center / scalar
		center.y = viewport_size.y - center.y
		center.y = center.y
		spriteMat.material.set_shader_parameter("center", center)
	elif blasting:
		if i == 0:
			center = center + Vector2(3100, -4000)
			center = center / scalar
			center.y = viewport_size.y - center.y
		center.y = center.y + i
		print(center)
		i = i - 0.5
		spriteMat.material.set_shader_parameter("center", center)


func _on_lindon_will_change(will):
	var prev_will = curWill
	curWill = curWill + will
	print(prev_will + curWill)


func _on_main_character_will_change(will):
	curWill = curWill + will


func _on_main_character_big_blast():
	animation_player.play("blast")
	blasting = true
	i = 0
