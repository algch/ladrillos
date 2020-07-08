extends Node2D

var brick_class = preload("res://brick.tscn")
var max_bricks = 8
var min_bricks = 2

var min_x = 80
var x_step = 80

func _input(event):
	if event.is_action_released("test"):
		spawn()

func spawn():
	move_brick_rows()
	var x = min_x
	for _i in range(max_bricks):
		if randi() % 4 == 0:
			var brick = brick_class.instance()
			brick.position.x = x
			brick.position.y = position.y
			get_parent().add_child(brick)
		x += x_step

func move_brick_rows():
	get_tree().call_group("bricks", "move_to_next_row")
