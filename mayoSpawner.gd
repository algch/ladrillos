extends Node2D

var mayo_class = preload("res://mayo.tscn")


func spawn():
	var mayo = mayo_class.instance()
	mayo.position = position
	get_parent().add_child(mayo)
