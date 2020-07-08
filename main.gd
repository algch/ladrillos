extends Node

func _ready():
	randomize()
	$brickSpawner.spawn()

func _on_player_shooted():
	$turnEnder.active = true

func _on_turnEnder_body_entered(body):
	pass
	# if not $turnEnder.active:
	# 	return

	# if body.is_in_group("bullets"):
	# 	if len(get_tree().get_nodes_in_group("bullets")) == 1:
	# 		$brickSpawner.spawn()
	# 		$turnEnder.active = false
	# 		$player.can_shoot = true
	# 	body.queue_free()
