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
	print("collided")
	if body.color == color:
		queue_free()
