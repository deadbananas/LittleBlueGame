extends CharacterBody2D

const UP = Vector2(0,-1)
const MAX_SPEED = 400 #Max speed in pixels per second
const ACCELERATION = 100 #acceleration rate
const FRICTION = 10 #deceleration rate
const minJump = 0 #to make fall instantly if height is lower than this
const STOP = 30.0
const JUMP_VELOCITY = -1200.0
const fall_mod_neg = -5
const fall_mod_pos = 700


var input_vector = Vector2.ZERO
var currentPosition = Vector2.ZERO
var positionUpdate = Vector2.ZERO


var friction = false
var lastDir = 0
var jumped = 0
var attacking = 0
@onready var sprite_2d = $Sprite2D
@onready var weapon = $Weapon

#state machine 

enum {
	IDLE,
	MOVE,
	JUMP,
	ATTACK
}
var state = IDLE
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func move():
	move_and_slide()
	if velocity.x >= 0:
		lastDir = 0
		sprite_2d.animation = "right"
	else:
		lastDir = 1
		sprite_2d.animation = "left"
func idleAnims():
	if lastDir == 1:
		sprite_2d.animation = "default_left"
	else:
		sprite_2d.animation = "default"
func airTime(delta):
	velocity.y += gravity * delta
	if velocity.y < fall_mod_neg:
		sprite_2d.animation = "jump_up"
	elif fall_mod_neg <= velocity.y and velocity.y <= fall_mod_pos:
		sprite_2d.animation = "jump_max"
	else:
		sprite_2d.animation = "fall"
		
func attack():
	print("placeholder")
func _physics_process(delta):
	playerInput()
	match state:
		IDLE:
			idleState()
		MOVE:
			moveState()
		JUMP:
			jumpState(delta)
		ATTACK:
			attackState()
			
func idleState():
	idleAnims()
	
func moveState():
	move()
	
func jumpState(delta):
	airTime(delta)
func attackState():	
	attack()

					
func playerInput():
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")	
	if input_vector.x >= 0.15 || input_vector.x <= -0.15:
		state = MOVE
		velocity.x = move_toward(velocity.x, input_vector.x*MAX_SPEED, ACCELERATION)
	else:
		state = IDLE
	#input_vector.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			
	if Input.is_action_just_pressed("jump"):
		print("hello")
		velocity.y = JUMP_VELOCITY
		sprite_2d.animation = "jump_up"
		state = JUMP
			
	if Input.is_action_just_released("jump") && velocity.y < minJump:
		velocity.y = 0
	
	if (Input.is_action_just_pressed("attack")):
		state = ATTACK


