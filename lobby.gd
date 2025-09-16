extends Node2D
@onready var lobby_cam = $lobbyCam
@onready var little_blue = $LittleBlue
@onready var animation_player = $AnimationPlayer
@onready var fight = $fight
@onready var dross = $Dross
@onready var dross_talk_check = $Dross/DrossTalkCheck

var goNext = true
var talkable = false
signal dialogicActive()
signal dialogicInactive()

# Called when the node enters the scene tree for the first time.
func _ready():
	goNext = true
	lobby_cam.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var anims = ['idle', 'Blink', 'mouth', 'wave']
	var item_weights = [50, 15, 5, 30]
	var anim = weighted_random_selector(anims, item_weights)
	animation_player.speed_scale = 0.5
	if goNext:
		animation_player.play(anim)
		goNext = false
	await animation_player.animation_finished
	goNext = true
	


func weighted_random_selector(anims: Array, weights: Array) -> String:
	var total_weight = 0
	for w in weights:
		total_weight += w
	
	var rnd = randi() % total_weight
	var cumulative = 0
	
	for i in range(anims.size()):
		cumulative += weights[i]
		if rnd < cumulative:
			return anims[i]
	
	return anims[0]


func _on_fight_body_entered(body):
	get_tree().change_scene_to_file("res://game.tscn")


func _input(event: InputEvent):
	if Dialogic.current_timeline != null:
			return
	if Input.is_action_just_pressed("talk") and talkable:
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start('lobbyTimeline')
		dialogicActive.emit()
		
		get_viewport().set_input_as_handled()


func _on_dross_talk_check_body_entered(body):
	talkable = true


func _on_dross_talk_check_body_exited(body):
	talkable = false

func _on_timeline_ended():
	dialogicInactive.emit()
