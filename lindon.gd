extends CharacterBody2D

@onready var lindon_anim = $AnimationPlayer
@onready var fiststrikebc = $fiststrikebc
@onready var lindon_sprite = $"fiststrikebc/LindonSprites"
@onready var burningCloak1 = $"fiststrikebc/burningCloak1"
var player = null
var play = 0
var slow_down = 0.07
var speed = 10000
var attack_accel = 1
var attack_move_speed = 10
var player_in_range = false

#attack velocities
var fist_strike_move_direction = 0 #0 for left, 1 for right
var fist_strike_move = false
var zero_y := Vector2(attack_move_speed,0)
var attacking = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("%main_character")
	burningCloak1.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player_in_range and player != null and !attacking:
		#velocity = position.direction_to(player.position) * speed * delta
		#lindon_sprite.flip_h = (position.x + 70 < player.position.x)
		#burningCloak1.flip_h = (position.x + 70 < player.position.x)
		if (position.x + 70 < player.position.x):
			fiststrikebc.scale.x  = -1.0
		else:
			fiststrikebc.scale.x  = 1.0
	
	if fist_strike_move:
		attack_accel = attack_accel + (100 * delta)
		if fist_strike_move_direction:
			var goal = Vector2(position.x + 1500 ,0)
			velocity = velocity.lerp(-1 * goal, attack_accel * delta)
			

		else:
			var goal = Vector2(position.x + 1500 ,0)
			velocity = velocity.lerp(goal,  attack_accel * delta)
	velocity.y = 0
	if velocity.x != 0:
		print(delta)
	move_and_slide()
		
func _on_timer_timeout():
	lindon_anim.play("fist-strike-BC")
	
	#blackflame.play("breath")

func _on_area_2d_body_entered(_body):
	player_in_range = true 
	
	
	
func fistStrikeBc():
	attacking = true
	var curPos = position
	var curX = curPos.x + 70
	var playerCurPos = player.position	
	#if !(abs(curX - playerCurPos.x) < 50):
	fist_strike_move = true
	if curX - playerCurPos.x > 0:
		fist_strike_move_direction = 1
	else:
		fist_strike_move_direction = 0
			
func zero_fist_Strike():
	fist_strike_move = false
	velocity.x = 0
	velocity.y = 0
	attack_accel = 1

func attacking_off():
	attacking = false
