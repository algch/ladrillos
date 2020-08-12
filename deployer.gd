extends Node2D

var player_class = preload("res://player.tscn")
export(float) var deploy_time = 3 

func _ready():
	$tween.interpolate_property($container/bar, "value", 0, 100, deploy_time)
	$tween.start()
	$deployTimer.set_wait_time(deploy_time)
	$deployTimer.start()


func _on_deployTimer_timeout():
	var player = player_class.instance()
	player.position = position
	get_parent().add_child(player)
	queue_free()
