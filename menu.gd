extends Control


var highest_score = 0


func _on_restart_pressed():
	get_tree().change_scene("res://main.tscn")

func _ready():
	var game_data = Utils.load_saved_data()
	highest_score = game_data["highest_score"]
	$vcontainer/hcontainer/scoreLbl.set_text(str(highest_score))
