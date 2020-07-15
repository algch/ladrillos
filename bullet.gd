extends KinematicBody2D

var direction = Vector2(0, 0)
var speed = 1250
var hits = 5

func destroy():
	get_parent().get_node("player").can_shoot = true
	queue_free()

func check_hits():
	if hits <= 0:
		destroy()

func _physics_process(delta):
	var motion = direction * speed * delta
	var collision = move_and_collide(motion, false)
	if collision:
		direction = direction.bounce(collision.normal)
		var collider = collision.collider
		if collider.has_method("handle_collision"):
			collider.handle_collision(collision, self)
		hits -= 1
		check_hits()
