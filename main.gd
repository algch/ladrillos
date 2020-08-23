extends Node2D

var expolsion_class = preload("res://explosion.tscn")
var deployer_class = preload("res://deployer.tscn")

var dir = Vector2()
var score = 0
var city_health = 100
var difficulty = 1

func play_effect(effect_name):
	if $effects.playing:
		return
	match effect_name:
		"mayo":
			var stream = load("res://audio/mayonesa_mc.wav")
			$effects.stream = stream
			$effects.play()
		"ay_perdon":
			var stream = load("res://audio/ay_perdon.wav")
			$effects.stream = stream
			$effects.play()
		"que_bruto":
			var stream = load("res://audio/que_bruto.wav")
			$effects.stream = stream
			$effects.play()

func _ready():
	randomize()

func _on_player_shooted():
	print("player shooted")

func _on_turnEnder_body_entered(body):
	var explosion = expolsion_class.instance()
	explosion.position = body.position
	get_parent().add_child(explosion)
	# TODO get damage from body
	city_health -= 10
	$cityHealth.value = city_health
	body.destroy(false)
	_check_city_health()

func _check_city_health():
	if city_health <= 0:
		get_tree().change_scene("res://menu.tscn")

func deploy_new_player():
	var deployer = deployer_class.instance()
	deployer.position = Vector2(280, 640)
	add_child(deployer)

func updateDifficulty():
	difficulty += 1.0/100.0 
	print("difficulty ", difficulty)

func increment_score(points):
	score += points
	$scoreLbl.set_text(str(score))
	updateDifficulty()
