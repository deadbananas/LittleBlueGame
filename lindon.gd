extends CharacterBody2D

@onready var anim_sprite = $fiststrikebc
@onready var anim_burningCloak1 = $fiststrikebc/burningCloak1
@onready var anim_LindonSprites = $fiststrikebc/LindonSprites
@onready var anim_fist_bc_strike = $fiststrikebc/fist_bc_strike
@onready var anim_transition_to_fist = $fiststrikebc/transition_to_fist
@onready var anim_walk_forward = $fiststrikebc/walk_forward
@onready var anim_kick_rock = $fiststrikebc/kick_rock
@onready var anim_basic_combo = $fiststrikebc/basic_combo
@onready var anim_player = $AnimationPlayer

@onready var game = get_tree().get_root().get_node("Game")
@onready var rock = load("res://rock.tscn")

@export var combo_dash_speed = 200
var player = null
var dir_to_player

const gravity = 50

var instance

func _ready():
	player = get_node("../%main_character")
	anim_burningCloak1.visible = false
	anim_LindonSprites.visible = false
	anim_fist_bc_strike.visible = false
	anim_transition_to_fist.visible = false
	anim_walk_forward.visible = false
	anim_kick_rock.visible = false
	anim_basic_combo.visible = false
	
func _physics_process(delta):
	move_and_slide()

func move(dir,speed):
	velocity.x = dir * speed
	handle_anims()
	update_flip(dir)
	
func moveAway(dir,speed):
	velocity.x = dir * speed
	handle_anims()
	update_flip(-dir)
	
func basic_combo_end_dash(dir, speed):
	velocity.x = dir * speed
	update_flip(dir)

func update_flip(dir):
	dir_to_player = dir
	if abs(dir) == dir:
		anim_sprite.scale.x  = -1.0
	else:
		anim_sprite.scale.x  = 1.0
		
func handle_anims():
	if velocity.x != 0:
		anim_walk_forward.visible = true
		anim_LindonSprites.visible = false
		anim_player.play("move")
		
	else:
		anim_walk_forward.visible = false
		anim_LindonSprites.visible = true
		anim_player.play("idle")

func basic_combo_anims_enter():
	anim_walk_forward.visible = false
	anim_LindonSprites.visible = false
	anim_basic_combo.visible = true
	
func basic_combo_anims_exit():
	anim_basic_combo.visible = false
	anim_LindonSprites.visible = true
	
func fist_strike_bc_anims_enter():
	anim_walk_forward.visible = false
	anim_LindonSprites.visible = false

func kick_rock_anims_enter():
	anim_walk_forward.visible = false
	anim_LindonSprites.visible = false
	anim_kick_rock.visible = true
	
func kick_rock_anims_exit():
	anim_kick_rock.visible = false
	anim_LindonSprites.visible = true
	
func spawn_rock():
	instance = rock.instantiate()
	instance.spawn_dir = dir_to_player
	instance.spawn_pos = global_position
	instance.spawn_rot = 0.0
	instance.zdex = z_index - 1
	instance.launch = false
	game.add_child.call_deferred(instance)
	
func launch_rock():
	instance.spawn_dir = dir_to_player
	instance.launch = true
#class_name Lindon
#extends CharacterBody2D
#
#@onready
#var animations = $AnimationPlayer
#@onready
#var state_machine = $state_machine
#@onready
#var move_component = $move_component
#
#func _ready() -> void:
	## Initialize the state machine, passing a reference of the player to the states,
	## that way they can move and react accordingly
	#state_machine.init(self, animations, move_component)
#
#func _unhandled_input(event: InputEvent) -> void:
	#state_machine.process_input(event)
#
#func _physics_process(delta: float) -> void:
	#state_machine.process_physics(delta)
#
#func _process(delta: float) -> void:
	#state_machine.process_frame(delta)
