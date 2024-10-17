extends CharacterBody2D

const UP = Vector2(0,-1)
const MAX_SPEED = 150 #Max speed in pixels per second
const ACCELERATION = 100 #acceleration rate
const FRICTION = 10 #deceleration rate




var jump_height = 100.0
var jump_time_to_peak = 0.5
var jump_time_to_descent = 0.39

@onready var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
const minJump = 0 #to make fall instantly if height is lower than this
const STOP = 30.0
const fall_mod_neg = -5
const fall_mod_pos = 700


var input_vector = Vector2.ZERO
var currentPosition = Vector2.ZERO
var positionUpdate = Vector2.ZERO


var friction = false
var jumped = 0
var attacking = 0
var mid_attack = 0
var attack_Q = 0
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
func get_gravity():
	return jump_gravity if velocity.y < 0 else fall_gravity

func move():
	if velocity.x > 0:
		sprite_2d.flip_h = false
	elif velocity.x < 0:
		sprite_2d.flip_h = true
	sprite_2d.play("right")
func idleAnims():
	sprite_2d.play("default")
func jumpAnims():
	if velocity.y < fall_mod_neg:
		sprite_2d.play("jump_up")
	elif fall_mod_neg <= velocity.y and velocity.y <= fall_mod_pos and !is_on_floor():
		sprite_2d.play("jump_max")
	else:
		sprite_2d.play("fall")
		
func attack():
	if !mid_attack:
		mid_attack = 1
		sprite_2d.play("attack1")
	if (attack_Q):
		sprite_2d.play("attack2")
		attack_Q = 0
func _physics_process(delta):
	playerInput(delta)
	match state:
		IDLE:
			idleState()
		MOVE:
			moveState()
		JUMP:
			jumpState()
		ATTACK:
			attackState()
			
func idleState():
	idleAnims()
	
func moveState():
	move()
func jumpState():
	jumpAnims()
func attackState():	
	attack()

					
func playerInput(delta):
	
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		state = JUMP
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")	
		velocity.x = move_toward(velocity.x, input_vector.x*MAX_SPEED, ACCELERATION)

	else:
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")	
		velocity.x = move_toward(velocity.x, input_vector.x*MAX_SPEED, ACCELERATION)
		if (input_vector.x >= 0.15 || input_vector.x <= -0.15):
			if !attacking:
				state = MOVE
		else:
			if !attacking:
				state = IDLE

	if Input.is_action_just_pressed("jump") and is_on_floor() and !attacking:
		velocity.y = jump_velocity
		sprite_2d.animation = "jump_up"
		state = JUMP

	if Input.is_action_just_released("jump") && velocity.y < minJump and !attacking:
		velocity.y = 0
	
	if (Input.is_action_just_pressed("attack")) and is_on_floor():
		if !attacking:
			state = ATTACK
			attacking = 1
			attack_Q = 0
		else:
			attack_Q = 1
	if attacking:
		velocity.x = velocity.x * 0.8
		velocity.y = velocity.y * 0.5
	move_and_slide()
	



func _on_sprite_2d_animation_finished():
	if (sprite_2d.animation == "attack1"):
		if (attack_Q):
			print("hya")
		else:
			attacking = 0
			mid_attack = 0	
	if (sprite_2d.animation == "attack2"):
		attack_Q = 0
		attacking = 0
		mid_attack = 0	


