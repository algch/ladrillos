extends Node


func load_saved_data():
	var game_data = {}
	var saved_data = File.new()
	if saved_data.file_exists("user://save_data.save"):
		saved_data.open("user://save_data.save", File.READ)
		game_data = parse_json(saved_data.get_line())
	saved_data.close()
	return game_data

func save_game_data(game_data):
	var saved_data = File.new()
	saved_data.open("user://save_data.save", File.WRITE)
	saved_data.store_line(to_json(game_data))
	saved_data.close()
