extends Node2D

var dir = Vector2()
var score = 0

func _ready():
	randomize()
	spawn()

func _on_player_shooted():
	print("player shooted")

func _on_turnEnder_body_entered(body):
	get_tree().quit()

func spawn():
	var spawners = get_tree().get_nodes_in_group("spawners")
	var spawner = spawners[ randi() % len(spawners) ]
	spawner.spawn()

func score(points):
	score += points
