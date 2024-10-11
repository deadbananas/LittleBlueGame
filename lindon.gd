extends CharacterBody2D

@onready var lindon_anim = $AnimationPlayer
@onready var blackflame = $AnimatedSprite2D
var play = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	lindon_anim.play("fist-strike-BC")
	#blackflame.play("breath")
