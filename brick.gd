extends KinematicBody2D

var explosion_class = preload("res://explosion.tscn")
var graphical_repr_class = preload("res://graphicalRepr.tscn")

var dir = Vector2()
var max_dir_speed = 300.0
var dir_speed = 0
var speed_decrease = 0
var gravity_speed = 300.0
var gravity_motion = Vector2.DOWN * gravity_speed

var max_health = 100
var health = max_health
var score = 1


func get_graphical_repr():
	var graphical_repr = graphical_repr_class.instance()
	graphical_repr.texture = $sprite.texture
	graphical_repr.original = self
	graphical_repr.transform = transform
	return graphical_repr

func get_repr_rotation():
	return $sprite.rotation

func destroy():
	var explosion = explosion_class.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	get_parent().increment_score(score)
	queue_free()

func check_health():
	if health <= 0:
		destroy()

func handle_collision(bounce_dir, bounce_speed):
	dir = bounce_dir
	dir_speed = bounce_speed if bounce_speed <= max_dir_speed else max_dir_speed
	speed_decrease = dir_speed/10
	$speedDecreaseTimer.start()

func _update_health_bar():
	$healthBar.value = $healthBar.max_value * (health/max_health)

func deal_damage(damage):
	health -= max_health * damage
	_update_health_bar()
	check_health()

func _process(_delta):
	$sprite.rotation += deg2rad(3)

func _physics_process(delta):
	var total_motion = (dir * dir_speed) + gravity_motion
	$tail.rotation = total_motion.normalized().angle() - PI/2
	var collision = move_and_collide(total_motion * delta)
	if collision:
		dir = dir.bounce(collision.normal).normalized()
		if collision.collider.has_method("handle_collision"):
			handle_collision(-dir, dir_speed)

		if collision.collider.has_method("deal_damage"):
			collision.collider.deal_damage(1)

func _on_speedDecreaseTimer_timeout():
	$speedDecreaseTimer.stop()
	dir_speed -= speed_decrease
	if dir_speed > 0:
		$speedDecreaseTimer.start()
