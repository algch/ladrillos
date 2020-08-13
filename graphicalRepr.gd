extends Sprite

var original
onready var x_delta = position.x - original.position.x

func _process(delta):
	position = original.position
	position.x += x_delta
	rotation = original.get_repr_rotation()
