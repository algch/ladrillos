extends Node2D

var expolsion_class = preload("res://explosion.tscn")

var dir = Vector2()
var score = 0

func _ready():
	randomize()
	spawn()

func _on_player_shooted():
	print("player shooted")

func _on_turnEnder_body_entered(body):
	var explosion = expolsion_class.instance()
	explosion.position = body.position
	get_parent().add_child(explosion)
	body.queue_free()

func spawn():
	var spawners = get_tree().get_nodes_in_group("spawners")
	var spawner = spawners[ randi() % len(spawners) ]
	spawner.spawn()

func increment_score(points):
	score += points
	$scoreLbl.set_text(str(score))
