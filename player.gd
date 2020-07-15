extends RigidBody2D

var bullet_class = preload("res://bullet.tscn")
var max_ammo = 1
var ammo = max_ammo

signal player_shooted

func _ready():
	connect("player_shooted", get_parent(), "_on_player_shooted")

func dash(dir):
	apply_central_impulse(dir * 400)
