class_name littleBlue
extends CharacterBody2D

@onready
var animations = $anims
@onready
var sprite = $LittleBlue_sheets
@onready
var state_machine = $state_machine
@onready
var move_component = $move_component
@onready var healthbar: ProgressBar = $UI/Healthbar

const Timeline = preload("res://addons/time_control/timeline.gd")

@export var timeline: Timeline


var health = 100
var maxHealth = 10

signal pass_strike()

var will = 0

signal will_change(will)

signal shrink_pass()

var double_jumped = false

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	
	# that way they can move and react accordingly
	healthbar.init_health(health)
	state_machine.init(self, animations, move_component, sprite)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
	if is_on_floor():
		double_jumped = false
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	ClockController.get_clock_by_key("PLAYER").local_time_scale = 1.0
	move_component.parry_pressed()
	move_component.shrink_pressed()
	state_machine.process_frame(delta)

func _on_hurtbox_received_hit(damage: int, time_scale: float, duration: float) -> void:
	health -= damage
	healthbar.health = health


func _on_lindon_strike_fist():
	pass_strike.emit()


func _on_hit_will_change(willDiff):
	will = willDiff
	will_change.emit(willDiff)


func _on_lindon_shrink_pass():
	shrink_pass.emit()
