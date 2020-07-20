extends KinematicBody2D

var dir = Vector2()
var dir_speed = 0
var speed_decrease = 0
var gravity_speed = 100
var gravity_motion = Vector2.DOWN * gravity_speed

var health = 0

func _ready():
	match randi() % 3:
		0:
			health = 2
		1:
			health = 3
		2:
			health = 4
	set_color()

func set_color():
	var color = Color(0, 0, 0)
	match health:
		1:
			color = Color(1, 0, 0)
		2:
			color = Color(0.8, 0.2, 1)
		3:
			color = Color(0.6, 0.4, 1)
		4:
			color = Color(0.4, 0.6, 1)
	$polygon.color = color

func check_health():
	if not health:
		queue_free()
	set_color()

func handle_collision(bounce_dir, bounce_speed):
	dir = bounce_dir
	dir_speed = bounce_speed
	speed_decrease = dir_speed/10
	$speedDecreaseTimer.start()

func deal_damage():
	health -= 1
	check_health()
	return health <= 0

func _physics_process(delta):
	var total_motion = (dir * dir_speed) + gravity_motion
	var collision = move_and_collide(total_motion * delta)
	if collision:
		dir = dir.bounce(collision.normal).normalized()
		if collision.collider.has_method("handle_collision"):
			handle_collision(-dir, dir_speed)

		if collision.collider.has_method("deal_damage"):
			collision.collider.deal_damage()

func _on_speedDecreaseTimer_timeout():
	$speedDecreaseTimer.stop()
	dir_speed -= speed_decrease
	if dir_speed > 0:
		$speedDecreaseTimer.start()
