extends KinematicBody2D

var dir = Vector2()
var dir_speed = 0
var speed_decrease = 0
var gravity_speed = 100
var gravity_motion = Vector2.DOWN * gravity_speed

var max_health = 0
var health = 0

func _ready():
	match randi() % 3:
		0:
			max_health = 200
			health = max_health
		1:
			max_health = 400
			health = max_health
		2:
			max_health = 600
			health = max_health

func check_health():
	if health <= 0:
		queue_free()

func handle_collision(bounce_dir, bounce_speed):
	dir = bounce_dir
	dir_speed = bounce_speed
	speed_decrease = dir_speed/10
	$speedDecreaseTimer.start()

func _update_health_bar():
	print("health ", health)
	$healthBar.value = $healthBar.max_value * (health/max_health)

func deal_damage(damage):
	print("damage ", damage)
	health -= damage
	_update_health_bar()
	check_health()

func _physics_process(delta):
	var total_motion = (dir * dir_speed) + gravity_motion
	$particles.rotation = total_motion.normalized().angle() - PI/2
	var collision = move_and_collide(total_motion * delta)
	if collision:
		dir = dir.bounce(collision.normal).normalized()
		if collision.collider.has_method("handle_collision"):
			handle_collision(-dir, dir_speed)

		if collision.collider.has_method("deal_damage"):
			collision.collider.deal_damage(dir_speed)

func _on_speedDecreaseTimer_timeout():
	$speedDecreaseTimer.stop()
	dir_speed -= speed_decrease
	if dir_speed > 0:
		$speedDecreaseTimer.start()
