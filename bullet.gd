extends KinematicBody2D

var direction = Vector2(0, 0)
var speed = 1250
var hits = 5

func check_hits():
	if hits <= 0:
		queue_free()
	if len(get_tree().get_nodes_in_group("bullets")) <= 1:
		get_parent().get_node("brickSpawner").spawn()
		get_parent().get_node("turnEnder").active = false
		get_parent().get_node("player").can_shoot = true

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
