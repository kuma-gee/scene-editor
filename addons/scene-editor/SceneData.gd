class_name SceneData extends Node

const GAME_SAVE_FILE = "res://scene.dat"

var _data := {}

func _ready():
	_load_data()

func _load_data() -> void:
	var file = File.new()
	var error = file.open(GAME_SAVE_FILE, File.READ)
	if error != OK:
		print("Failed to load scene data")
		return
	
	_data = file.get_var()
	file.close()

func get_available_scenes() -> Array:
	var current = current_scene()
	if _data.has(current):
		return _data[current]
	return []

func current_scene() -> String:
	return get_tree().current_scene.filename
