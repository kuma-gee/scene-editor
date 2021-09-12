class_name SceneData extends Node

const GAME_SAVE_FILE = "res://scene.dat"

enum Type {
	BACK,
	FORWARD,
	GLOBAL,
}

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

func _get_available_scenes() -> Array:
	var current = current_scene()
	if _data.has(current):
		return _data[current]
	return []

func current_scene() -> String:
	return get_tree().current_scene.filename


func find_scene(name := "", type := Type.FORWARD) -> String:
	var scenes = _get_available_scenes()
	var find_name = name
	if not find_name.ends_with(".tscn"):
		find_name += ".tscn"
	
	for scene in scenes:
		if scene["type"] == type and scene["scene"].ends_with(find_name):
			return scene["scene"]
	
	return scenes[0]["scene"] if scenes.size() > 0 and scenes[0]["type"] == type else ""
