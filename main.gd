extends Node2D

var expolsion_class = preload("res://explosion.tscn")
var deployer_class = preload("res://deployer.tscn")

var dir = Vector2()
var score = 0
var city_health = 100

func _ready():
	randomize()
	spawn()

func _on_player_shooted():
	print("player shooted")

func _on_turnEnder_body_entered(body):
	var explosion = expolsion_class.instance()
	explosion.position = body.position
	get_parent().add_child(explosion)
	# TODO get damage from body
	city_health -= 10
	$cityHealth.value = city_health

	body.destroy()

func deploy_new_player():
	var deployer = deployer_class.instance()
	deployer.position = Vector2(360, 640)
	add_child(deployer)

func spawn():
	var spawners = get_tree().get_nodes_in_group("spawners")
	var spawner = spawners[ randi() % len(spawners) ]
	spawner.spawn()

func increment_score(points):
	score += points
	$scoreLbl.set_text(str(score))
