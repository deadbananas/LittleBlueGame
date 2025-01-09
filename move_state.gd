extends LimboState
## PlayAnimation: Play an animation on AnimationPlayer, and wait for it to finish.

@export var animation_player: AnimationPlayer
@export var animation_name: StringName

var count = 1 
func _enter() -> void:
	print("move")

func _update(_delta: float) -> void:
	count += 1
	
	if count > 50:
		dispatch(EVENT_FINISHED)
