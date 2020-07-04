extends KinematicBody2D

var direction = Vector2(0, 0)
var speed = 750

func _physics_process(delta):
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)
	if collision:
		direction = direction.bounce(collision.normal)
		var collider = collision.collider
		if collider.has_method("handle_collision"):
			collider.handle_collision(collision, self)
