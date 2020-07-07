extends Node

func _ready():
	randomize()
	$brickSpawner.spawn()

func _on_player_shooted():
	$turnEnder.active = true

func _on_turnEnder_body_entered(body):
	if not $turnEnder.active:
		return

	if body is KinematicBody2D:
		if len(get_tree().get_nodes_in_group("bullets")) == 1:
			$brickSpawner.spawn()
			$turnEnder.active = false
		body.queue_free()
