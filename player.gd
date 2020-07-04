extends Node2D

var bullet_class = preload("res://bullet.tscn")
var max_ammo = 5
var ammo = max_ammo
var can_shoot = true
var dir = Vector2(0, 0)

func _on_refreshTimer_timeout():
	var bullet = bullet_class.instance()
	bullet.position = position
	bullet.direction = dir
	get_parent().add_child(bullet)
	ammo -= 1
	if ammo:
		$refreshTimer.start()
	else:
		$refreshTimer.stop()
		can_shoot = true
		ammo = max_ammo

func _input(event):
	if event.is_action_released("shoot") and can_shoot:
		can_shoot = false
		dir = (get_global_mouse_position() - position).normalized()
		$refreshTimer.start()
