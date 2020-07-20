extends KinematicBody2D

var bullet_class = preload("res://bullet.tscn")

signal player_shooted

var can_shoot = true
var aim_start = null
var is_aiming = false
var can_deal_damage = false
var is_refreshing = false
var dir = Vector2()
var max_dir_speed = 500
var speed_decrease = 50
var dir_speed = max_dir_speed

var gravity_speed = 100
var gravity_motion = Vector2.DOWN * gravity_speed


func _ready():
	connect("player_shooted", get_parent(), "_on_player_shooted")

func _input(event):
	if event.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		is_aiming = true
		aim_start = get_global_mouse_position()

	if event.is_action_released("shoot") and not is_refreshing:
		is_aiming = false
		can_deal_damage = true
		is_refreshing = true
		dir = (aim_start - get_global_mouse_position()).normalized()
		dir_speed = max_dir_speed
		$speedDecreaseTimer.start()
		$polygon.color = Color(1, 0, 0)
		$refreshTimer.start()

func _process(delta):
	update()
	if is_aiming:
		$polygon.rotation = (aim_start - get_global_mouse_position()).angle() + PI/2 - rotation

func _draw():
	if not is_aiming:
		return
	var start = aim_start - position
	var end = get_global_mouse_position() - position
	draw_line(start, end, Color(1, 1, 1), 2)

func _physics_process(delta):
	var dir_motion = dir * dir_speed
	var total_motion = dir_motion + gravity_motion
	var collision = move_and_collide(total_motion * delta)
	if collision:
		var prev_dir = dir
		dir = dir.bounce(collision.normal).normalized()
		if collision.collider.has_method("handle_collision"):
			collision.collider.handle_collision(-dir, dir_speed)

		if collision.collider.has_method("deal_damage") and can_deal_damage:
			var destroyed = collision.collider.deal_damage()
			if destroyed:
				dir = prev_dir
			can_deal_damage = false
			$polygon.color = Color(1, 1, 1)

func _on_speedDecreaseTimer_timeout():
	$speedDecreaseTimer.stop()
	dir_speed -= speed_decrease
	if dir_speed > 0:
		$speedDecreaseTimer.start()
	else:
		can_deal_damage = false
		$polygon.color = Color(1, 1, 1)

func _on_refreshTimer_timeout():
	can_shoot = true
	is_refreshing = false
