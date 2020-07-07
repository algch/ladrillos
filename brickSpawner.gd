extends Node2D

var brick_class = preload("res://brick.tscn")
var max_bricks = 8
var min_bricks = 2

var min_x = 80
var x_step = 80

func _input(event):
	if event.is_action_released("test"):
		spawn()

func get_brick_distribution(bricks):
	var spaces = {}
	var spaces_count = max_bricks - bricks
	while len(spaces) < spaces_count:
		var place = randi() % max_bricks
		if not (place in spaces):
			spaces[place] = true
	var result  = []
	for i in range(bricks):
		if i in spaces:
			result.append(false)
		else:
			result.append(true)
	return result

func spawn():
	move_brick_rows()
	var bricks = (randi() % (max_bricks - min_bricks + 1)) + min_bricks
	var distribution = get_brick_distribution(bricks)
	var x = min_x
	for should_build in distribution:
		if should_build:
			var brick = brick_class.instance()
			brick.position.x = x
			brick.position.y = position.y
			get_parent().add_child(brick)
		x += x_step

func move_brick_rows():
	get_tree().call_group("bricks", "move_to_next_row")
