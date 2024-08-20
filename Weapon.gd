extends Area2D

@onready var anim = $AnimationPlayer

func attack():
	anim.play("swing")
