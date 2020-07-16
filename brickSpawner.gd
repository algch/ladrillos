extends Node2D

var brick_class = preload("res://brick.tscn")

func spawn():
	var brick = brick_class.instance()
	brick.position = position
	get_parent().add_child(brick)

func is_close_to_ball():
	pass
