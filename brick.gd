extends RigidBody2D

var bullet_class = preload("res://bullet.tscn")

var hits = 0
var min_hits = 1
var max_hits = 3

var y_step = 80

func _ready():
	hits = (randi() % (max_hits + 1)) + min_hits
	$Label.set_text(str(hits))

func check_hits():
	if hits <= 0:
		queue_free()
		var dir = Vector2.UP
		for _i in range(4):
			var bullet = bullet_class.instance()
			bullet.direction = dir
			bullet.position = position
			bullet.rotation = rotation
			get_parent().add_child(bullet)
			dir = dir.rotated(PI/2)

func handle_collision(collision, collider):
	apply_central_impulse(-collision.normal * 500)
	hits -= 1
	$Label.set_text(str(hits))
	check_hits()
