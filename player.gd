extends Node2D

var bullet_class = preload("res://bullet.tscn")
var max_ammo = 5
var ammo = max_ammo
var can_shoot = true
var dir = Vector2(0, 0)

signal player_shooted

func _ready():
	connect("player_shooted", get_parent(), "_on_player_shooted")

func _on_refreshTimer_timeout():
	var bullet = bullet_class.instance()
	bullet.position = position
	bullet.direction = dir
	get_parent().add_child(bullet)
	ammo -= 1
	$refreshTimer.start()
	if not ammo:
		$refreshTimer.stop()
		ammo = max_ammo
		can_shoot = true

func _input(event):
	if event.is_action_released("shoot") and can_shoot:
		can_shoot = false
		dir = (get_global_mouse_position() - position).normalized()
		emit_signal("player_shooted")
		_on_refreshTimer_timeout()
