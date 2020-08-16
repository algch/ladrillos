extends Area2D

func _on_downPusher_body_entered(body):
	if body.is_in_group("player"):
		body.dir_speed *= 0.3
