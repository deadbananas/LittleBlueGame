extends CharacterBody2D

@onready var lindon_anim = $AnimationPlayer
@onready var lindon_sprite = $LindonSprites
var player = null
var play = 0
var slow_down = 0.07
var speed = 10000
var attack_move_speed = 1000000
var player_in_range = false

#attack velocities
var fist_strike_move_direction = 0 #0 for left, 1 for right
var fist_strike_move = false
var zero_y  := Vector2(1,0)
var attacking = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("%main_character")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player_in_range and player != null and !attacking:
		#velocity = position.direction_to(player.position) * speed * delta
		lindon_sprite.flip_h = (position.x + 70 < player.position.x)
	if fist_strike_move:
		if fist_strike_move_direction:
			var playPos := Vector2()
			playPos.x = player.position.x - 30
			velocity = (playPos - position).normalized() * zero_y * attack_move_speed * delta
		else:
			var playPos := Vector2()
			playPos.x = player.position.x - 80
			velocity = (playPos - position).normalized() * zero_y * attack_move_speed * delta
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


func attacking_off():
	attacking = false
