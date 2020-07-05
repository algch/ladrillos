extends Area2D

func _on_positioner_body_entered(body):
	if body.is_in_group("bullets"):
		print("player position should be ", str(body.position))
