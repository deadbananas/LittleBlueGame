extends CharacterBody2D

@onready var anim_sprite = $rock_sprite

@onready var anim_player = $AnimationPlayer

@export var speed = 1000

var spawn_dir : float
var spawn_pos : Vector2
var spawn_rot : float
var zdex : int
var launch : bool

func _ready():
	global_position = spawn_pos
	global_rotation = spawn_rot
	z_index = zdex
	if abs(spawn_dir) == spawn_dir:
		anim_player.play("spawn_right")
	else:
		anim_player.play("spawn_left")

func _physics_process(delta):
	if launch:
		velocity.x = spawn_dir * speed
	move_and_slide()

func move(dir,speed):
	velocity.x = dir * speed
	update_flip(dir)

func update_flip(dir):
	if abs(dir) == dir:
		anim_sprite.scale.x  = -1.0
	else:
		anim_sprite.scale.x  = 1.0
		


func _on_life_timeout():
	queue_free()
