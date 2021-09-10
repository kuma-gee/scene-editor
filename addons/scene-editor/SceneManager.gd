extends Node

onready var scene_data := $SceneData

func change_scene(scene_name: String = "") -> void:
	var scene = _find_scene(scene_name)
	if scene != "":
		get_tree().change_scene(scene)

func _find_scene(name: String = "") -> String:
	var scenes = scene_data.get_available_scenes()
	var find_name = name
	if not find_name.ends_with(".tscn"):
		find_name += ".tscn"
	
	for scene in scenes:
		if scene.ends_with(find_name):
			return scene
	
	return scenes[0] if scenes.size() > 0 else ""
