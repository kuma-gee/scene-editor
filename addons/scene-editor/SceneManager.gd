extends Node

onready var scene_data := $SceneData

func next_scene(idx := 0) -> void:
	var scenes = scene_data.get_available_scenes()
	if idx >= 0 and idx < scenes.size():
		get_tree().change_scene(scenes[idx])
