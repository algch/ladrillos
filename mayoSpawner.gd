extends Node2D

var mayo_class = preload("res://mayo.tscn")
onready var main = get_node("..")
onready var dist = $p2.position.x - $p1.position.x
var initial_probability = 0.4
var probability = initial_probability


func _ready():
	restart_timer()

func spawn():
	var mayo = mayo_class.instance()
	mayo.position = position + $p1.position
	mayo.position.x += $p1.position.x + (randi() % int(dist))
	get_parent().add_child(mayo)

func restart_timer():
	$spawnTimer.set_wait_time(randi() % 3)
	$spawnTimer.start()

func _on_spawnTimer_timeout():
	if randf() <= probability:
		spawn()
		probability = initial_probability * main.difficulty
		print("probability ", probability)

	restart_timer()
