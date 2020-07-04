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
	var r = (randi() % (max_bricks - min_bricks + 1)) + min_bricks
	var x = min_x
	for i in range(r):
		var brick = brick_class.instance()
		brick.position.x = x
		x += x_step
		brick.position.y = position.y
		get_parent().add_child(brick)

func move_brick_rows():
	get_tree().call_group("bricks", "move_to_next_row")
