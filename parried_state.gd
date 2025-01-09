extends LimboState
## PlayAnimation: Play an animation on AnimationPlayer, and wait for it to finish.

@export var animation_player: AnimationPlayer
@export var animation_name: StringName

func _enter() -> void:
	animation_player.play(animation_name)
	print("lindon parried state entered pog pog pog")

func _update(_delta: float) -> void:
	if not animation_player.is_playing() \
			or animation_player.assigned_animation != animation_name:
		print("finish")
		dispatch(EVENT_FINISHED)
