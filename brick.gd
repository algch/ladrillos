extends RigidBody2D

var color = null

func _ready():
	match randi() % 2:
		0:
			color = Color(1, 0, 0)
		1:
			color = Color(0, 0, 1)
	$polygon.color = color

func _on_brick_body_entered(body):
	if not body.is_in_group("bricks"):
		return

	if body.color == color:
		queue_free()
		get_node("/root/main/").score()

func is_close_to_ball():
	for ball in get_tree().get_nodes_in_group("bricks"):
		if position.distance_to(ball.position) < 100:
			return true
	return false
