extends Area2D

export(NodePath) var endPath
onready var end = get_node(endPath)

func _on_portal_body_entered(body):
	body.position.x = end.position.x
