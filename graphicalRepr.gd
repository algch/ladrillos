extends Node2D

var original
onready var x_delta = position.x - original.position.x

func set_texture(node_name, texture):
	get_node(node_name).set_texture(texture)

func set_frames(frames):
	$animation.set_sprite_frames(frames)

func play(animation, frame):
	$animation.set_frame(frame)
	$animation.play(animation)

func _process(_delta):
	if not is_instance_valid(original):
		return

	position = original.position
	position.x += x_delta
	rotation = original.get_repr_rotation()
