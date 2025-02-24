extends LimboState
## PlayAnimation: Play an animation on AnimationPlayer, and wait for it to finish.

@export var animation_player: AnimationPlayer
@export var animation_name: StringName

@onready var fist_strike_hitbox = $"../../fiststrikebc/LindonSprites/blackflame_fist_Strike_hitbox/fist_strike_hitbox"

@onready var cloak_hitbox_shape_in = $"../../fiststrikebc/LindonSprites/cloak_hitbox/cloak_hitbox_shape_in"

@onready var cloak_shape_out = $"../../fiststrikebc/LindonSprites/cloak_hitbox/cloak_shape_out"

@onready var fist = $"../../fiststrikebc/LindonSprites/cloak_hitbox/fist"

@onready var rock_hitbox_shape = $"../../fiststrikebc/kick_rock/rock_hit_hitbox/rock_hitbox_shape"

@onready var basic_combo_shape = $"../../fiststrikebc/basic_combo/basic_combo_hitbox/basic_combo_shape"


@onready var phase_1 = $"../Phase1"

func _enter() -> void:
	animation_player.play(animation_name)

func _update(_delta: float) -> void:
	fist_strike_hitbox.disabled = true
	cloak_hitbox_shape_in.disabled = true
	cloak_shape_out.disabled = true
	fist.disabled = true
	rock_hitbox_shape.disabled = true
	basic_combo_shape.disabled = true
	if not animation_player.is_playing() \
			or animation_player.assigned_animation != animation_name:
		dispatch(EVENT_FINISHED)
		
