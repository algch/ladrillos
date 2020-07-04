extends StaticBody2D

var hits = 0
var min_hits = 5

var y_step = 80

func _ready():
	hits = (randi() % (min_hits + 1)) + min_hits
	$Label.set_text(str(hits))

func check_hits():
	if hits <= 0:
		queue_free()

func handle_collision(collision, collider):
	print("handle collision")
	hits -= 1
	$Label.set_text(str(hits))
	check_hits()

func move_to_next_row():
	position.y += y_step
