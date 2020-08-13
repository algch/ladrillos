extends Node2D

var original_2_repr = {}
onready var h_dist_between_portals = $left.position.x + $right.position.x

func _spawn_graphical_repr(body, x_delta):
	var graphical_repr = body.get_graphical_repr()
	graphical_repr.position.x += x_delta
	get_parent().add_child(graphical_repr)
	original_2_repr[body.get_instance_id()] = graphical_repr

func _teleport_body(body):
	if body.get_instance_id() in original_2_repr:
		var graphical_repr = original_2_repr[body.get_instance_id()]
		if body.position.x < $left.position.x or body.position.x > $right.position.x:
			body.position.x = graphical_repr.position.x
		graphical_repr.queue_free()
		original_2_repr.erase(body.get_instance_id())

func _on_left_body_entered(body):
	if body.has_method("get_graphical_repr"):
		_spawn_graphical_repr(body, h_dist_between_portals)

func _on_left_body_exited(body):
	_teleport_body(body)

func _on_right_body_entered(body):
	if body.has_method("get_graphical_repr"):
		_spawn_graphical_repr(body, -h_dist_between_portals)

func _on_right_body_exited(body):
	_teleport_body(body)
