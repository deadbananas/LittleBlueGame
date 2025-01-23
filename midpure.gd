extends Sprite2D


func flash():
	material.set_shader_parameter("flash_mod", 1.00)
	var flashTimer : Timer = Timer.new()
	add_child(flashTimer)
	flashTimer.one_shot = true
	flashTimer.autostart = true
	flashTimer.wait_time = 3.5
	flashTimer.timeout.connect(timer_timeout)
	flashTimer.start()


func timer_timeout():
	material.set_shader_parameter("flash_mod", 0.0)


func _on_lindon_mid_pure():
	flash()
