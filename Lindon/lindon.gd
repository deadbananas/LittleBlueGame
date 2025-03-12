extends CharacterBody2D

@onready var hsm: LimboHSM = $LimboHSM
@onready var phase_1_state: LimboState = $LimboHSM/Phase1
@onready var parried_state: LimboState = $LimboHSM/ParriedState
@onready var shrunk_countered_state: LimboState = $LimboHSM/ShrunkCounterState
@onready var phase_1 = $LimboHSM/Phase1
@onready var bf_shader_holder = $fiststrikebc/bfShaderHolder


@onready var anim_sprite = $fiststrikebc
@onready var anim_burningCloak1 = $fiststrikebc/burningCloak1
@onready var anim_LindonSprites = $fiststrikebc/LindonSprites
@onready var anim_fist_bc_strike = $fiststrikebc/fist_bc_strike
@onready var anim_transition_to_fist = $fiststrikebc/transition_to_fist
@onready var anim_walk_forward = $fiststrikebc/walk_forward
@onready var anim_kick_rock = $fiststrikebc/kick_rock
@onready var anim_basic_combo = $fiststrikebc/basic_combo
@onready var anim_parried = $fiststrikebc/Parried_Sprite


@onready var fist_strike_hitbox = $fiststrikebc/LindonSprites/blackflame_fist_Strike_hitbox/fist_strike_hitbox
@onready var cloak_hitbox_shape_in = $fiststrikebc/LindonSprites/cloak_hitbox/cloak_hitbox_shape_in
@onready var cloak_shape_out = $fiststrikebc/LindonSprites/cloak_hitbox/cloak_shape_out
@onready var fist = $fiststrikebc/LindonSprites/cloak_hitbox/fist
@onready var rock_hitbox_shape = $fiststrikebc/kick_rock/rock_hit_hitbox/rock_hitbox_shape
@onready var basic_combo_shape = $fiststrikebc/basic_combo/basic_combo_hitbox/basic_combo_shape


@onready var fist_check = $fistCheck
@onready var shrink_check = $shrinkCheck
@onready var shrink_start_check = $shrinkStartCheck

@onready var healthbar = $UI/Healthbar
@onready var color_rect = $CanvasLayer/ColorRect

@onready var anim_player = $AnimationPlayer

@onready var hurtbox_main = $hurtbox_main


@onready var game = get_tree().get_root().get_node("Game")
@onready var rock = load("res://rock.tscn")
@onready var shockwave = preload("res://shockwave.tscn")

@export var combo_dash_speed = 200
var player = null
var dir_to_player
var spriteMat
var bf_spriteMat
const gravity = 50

var fist_check_area_entered = false
var move_on = false
var instance

var parried_check = false

var will = 0.0
var willDiff = 0.0
var prevWill = 0.0

signal mid_pure()

signal will_change(willDiff)

signal strike_Fist()

signal shrink_Pass()

var health = 100

const Timeline = preload("res://addons/time_control/timeline.gd")

@export var timeline: Timeline
var timeScale = 1.0

func _ready():
	player = get_node("../%main_character")
	health = 100
	healthbar.init_health(health)
	anim_burningCloak1.visible = false
	anim_LindonSprites.visible = false
	anim_fist_bc_strike.visible = false
	anim_transition_to_fist.visible = false
	anim_walk_forward.visible = false
	anim_kick_rock.visible = false
	anim_basic_combo.visible = false
	anim_parried.visible = false
	parried_check = false
	will = 0.0
	prevWill = 0.0
	willDiff = 0.0
	spriteMat = get_node("fiststrikebc/Parried_Sprite")
	bf_spriteMat = get_node("fiststrikebc/slammed_down")
	_init_state_machine()
	
	
	
	
	
func _init_state_machine() -> void:
	hsm.add_transition(phase_1_state, parried_state, phase_1_state.EVENT_FINISHED)
	hsm.add_transition(hsm.ANYSTATE, parried_state, &"parried")
	hsm.add_transition(parried_state, phase_1_state, parried_state.EVENT_FINISHED)
	hsm.add_transition(hsm.ANYSTATE, shrunk_countered_state, &"shrunk")
	hsm.add_transition(shrunk_countered_state, phase_1_state, shrunk_countered_state.EVENT_FINISHED)

	hsm.initialize(self)
	hsm.set_active(true)
	
	
	
	
func _physics_process(delta):
	ClockController.get_clock_by_key("ENEMY").local_time_scale = timeScale
	if Input.is_action_just_pressed("attack"):
			dragonsBreathScale(10)
	anim_player.speed_scale = timeScale
	if color_rect == null:
		var instance = shockwave.instantiate()
		add_child(instance)
		color_rect = $CanvasLayer/ColorRect
	if will != prevWill:
		will_update()
	move_and_slide()

func move(dir,speed):
	velocity.x = dir * speed * timeline.time_scale
	handle_anims()
	update_flip(dir)
	
func moveAway(dir,speed):
	velocity.x = dir * speed * timeline.time_scale
	handle_anims()
	update_flip(-dir)
	
func basic_combo_end_dash(dir, speed):
	velocity.x = dir * speed * timeline.time_scale
	update_flip(dir)

func update_flip(dir):
	dir_to_player = dir
	if abs(dir) == dir:
		anim_sprite.scale.x  = -1.0
		fist_check.scale.x = -1.0
		hurtbox_main.scale.x = -1.0
		shrink_start_check.scale.x = -1.0
		shrink_check.scale.x = -1.0
	else:
		anim_sprite.scale.x  = 1.0
		fist_check.scale.x = 1.0
		hurtbox_main.scale.x = 1.0
		shrink_start_check.scale.x = 1.0
		shrink_check.scale.x = 1.0
		
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
	move_on = false
	
func fist_strike_bc_anims_enter():
	fist_check_area_entered = false
	anim_walk_forward.visible = false
	anim_LindonSprites.visible = false
	
func fist_strike_bc_anims_exit():
	fist_check_area_entered = false

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
	
	
	
func will_update():
	willDiff = prevWill + will
	prevWill = 0.0
	will = 0.0
	will_change.emit(willDiff)
	
	
	
func countered():
	fist_strike_hitbox.disabled = true
	cloak_hitbox_shape_in.disabled = true
	cloak_shape_out.disabled = true
	fist.disabled = true
	rock_hitbox_shape.disabled = true
	basic_combo_shape.disabled = true
	hsm.dispatch("parried")
	velocity.x = 0
	velocity.y = 0
	fist_check_area_entered = false
	anim_burningCloak1.visible = false
	anim_LindonSprites.visible = false
	anim_fist_bc_strike.visible = false
	anim_transition_to_fist.visible = false
	anim_walk_forward.visible = false
	anim_kick_rock.visible = false
	anim_basic_combo.visible = false
	anim_parried.visible = true
	flash()
	
	
func parried():
	timeScale = 0.5
	var parryTimer : Timer = Timer.new()
	add_child(parryTimer)
	parryTimer.one_shot = true
	parryTimer.autostart = true
	parryTimer.wait_time = 0.2
	parryTimer.timeout.connect(parry_timer_timeout)
	parryTimer.start()
	will -= 3
	
func flash():
	spriteMat.material.set_shader_parameter("flash_mod", 0.98)
	bf_spriteMat.material.set_shader_parameter("flash_mod", 0.98)
	var flashTimer : Timer = Timer.new()
	add_child(flashTimer)
	flashTimer.one_shot = true
	flashTimer.autostart = true
	flashTimer.wait_time = 0.7
	flashTimer.timeout.connect(flash_timer_timeout)
	flashTimer.start()
	
	
func flash_timer_timeout():
	spriteMat.material.set_shader_parameter("flash_mod", 0.0)
	bf_spriteMat.material.set_shader_parameter("flash_mod", 0.0)
func parry_timer_timeout():
	timeScale = 1
	
func set_move_on():
	move_on = true
	
func get_move_on():
	return move_on
	
func get_fist_check_area_entered():
	return fist_check_area_entered

func emit_mid_pure():
	fist_check_area_entered = false
	mid_pure.emit()
	
func emit_fist_strike():
	strike_Fist.emit()

func _on_blackflame_fist_strike_hitbox_parried_signal(damage: Variant) -> void:
	pass


func _on_cloak_hitbox_parried_signal(damage: Variant) -> void:
	pass


func _on_rock_hit_hitbox_parried_signal(damage: Variant) -> void:
	parried()


func _on_basic_combo_hitbox_parried_signal(damage: Variant) -> void:
	parried()


func _on_fist_check_area_entered(area):
	fist_check_area_entered = true


func _on_hurtbox_main_received_hit(damage, time_scale, duration):
	print(duration)
	health -= damage
	healthbar.health = health
	will -= 0.5


func _on_shrink_check_area_entered(area):
	if timeScale == 0.1:
		shrink_Pass.emit()
		var shrunkenTimer : Timer = Timer.new()
		add_child(shrunkenTimer)
		shrunkenTimer.one_shot = true
		shrunkenTimer.autostart = true
		shrunkenTimer.wait_time = 1.4
		shrunkenTimer.timeout.connect(shrunkenTimer_timer_timeout)
		shrunkenTimer.start()
		

func shrunkenTimer_timer_timeout():
	hsm.dispatch("shrunk")
	flash()
	timeScale = 1.0

func _on_main_character_time_slow():
	if timeScale == 1:
		timeScale = 0.1
	else:
		timeScale = 1


func distortionSlam():
	color_rect.set_distortion_center(Vector2(position.x, position.y - 80))
	fist_check_area_entered = false
	
	
	
func dragonsBreathScale(scaleX):
	bf_shader_holder.scale.x = -scaleX
	bf_shader_holder.material.set_shader_parameter("noise_scale", Vector2(scaleX * 1.5, 1))
	bf_shader_holder.material.set_shader_parameter("shader_parameter/progress", 0)
	bf_shader_holder.visible = true
	var tween = get_tree().create_tween()
	#tween.parallel().tween_property(bf_shader_holder, "scale", Vector2(-scaleX, 92.5), 1)
	#tween.parallel().tween_property(bf_shader_holder.material, "shader_parameter/noise_scale", Vector2(scaleX * 1.5, 1), 1)
	tween.chain().tween_property(bf_shader_holder.material, "shader_parameter/progress", 0.25, 0.01)
	tween.chain().tween_property(bf_shader_holder.material, "shader_parameter/progress", 0, 0.2)
	#bf_shader_holder.self_modulate.a = 1
	tween.chain().tween_property(bf_shader_holder.material, "shader_parameter/progress", 0, 1)
	tween.chain().tween_property(bf_shader_holder.material, "shader_parameter/progress", 1, 0.25)
	tween.chain().tween_property(bf_shader_holder.material, "shader_parameter/progress", 1, 2)
	tween.chain().tween_property(bf_shader_holder.material, "shader_parameter/progress", 0, 1)
	tween.chain().tween_property(bf_shader_holder.material, "shader_parameter/progress", 0, 5)
	await  tween.finished
	bf_shader_holder.visible = false


	
