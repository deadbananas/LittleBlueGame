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
@onready var color_rect = $CanvasLayer/ColorRect
@onready var camera_2d = $Camera2D

const Timeline = preload("res://addons/time_control/timeline.gd")

@export var timeline: Timeline


var health = 100
var maxHealth = 10

signal pass_strike()

var will = 0

signal will_change(will)

signal shrink_pass()

signal big_blast()

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
	
	
func emit_big_blast():
	#var viewport_size := get_viewport_rect().size
	#var zoomed_view = viewport_size / camera_2d.zoom
#
	#var cam_relative_pos = (global_position - camera_2d.get_screen_center_position()) \
	#+ zoomed_view / 2.0
	#var ratio = zoomed_view.x / zoomed_view.y
#
	#var x = cam_relative_pos.x / zoomed_view.x
	#var y = cam_relative_pos.y / zoomed_view.y
	#x = (x - 0.5) * ratio + 0.5 # reversing the effect of scaling in shader
	#var projection = (get_global_position() - camera_2d.get_global_position())
	#color_rect.material.set_shader_parameter("shader_parameter/global_position", Vector2(x,y))
	#color_rect.visible = true
	color_rect.set_distortion_center(Vector2(position.x, position.y - 80))
	#var tween = get_tree().create_tween()
	
	#tween.tween_property(color_rect.material, "shader_parameter/size", 2.0, 2.0)
	#tween.tween_callback(hide_shader_rect)
	#big_blast.emit()

func hide_shader_rect():
	color_rect.visible = false
