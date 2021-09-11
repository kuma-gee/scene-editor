extends Node

export var use_transition := true

onready var scene_data := $SceneData
onready var transition := $TransitionLayer/Transition

var next_scene := ""

func change_scene(scene_name: String = "", back := false) -> void:
	var scene = _find_scene(scene_name, back)
	if scene != "":
		if use_transition:
			next_scene = scene
			_leave_scene_transition()
		else:
			get_tree().change_scene(scene)

func _find_scene(name := "", back := false) -> String:
	var scenes = scene_data.get_available_scenes()
	var find_name = name
	if not find_name.ends_with(".tscn"):
		find_name += ".tscn"
	
	for scene in scenes:
		if scene["back"] == back and scene["scene"].ends_with(find_name):
			return scene["scene"]
	
	return scenes[0]["scene"] if scenes.size() > 0 and scenes[0]["back"] == back else ""


func _leave_scene_transition() -> void:
	transition.show()
	transition.reverse = true
	transition.start()

func _enter_scene_transition() -> void:
	transition.reverse = false
	transition.start()

func _is_enter_transition() -> bool:
	return not transition.reverse

func _on_Transition_finished():
	# Finished enter transition
	if _is_enter_transition():
		transition.hide()

	# Finished leave transition
	if transition.reverse and next_scene != "":
		get_tree().change_scene(next_scene)
		next_scene = ""
		_enter_scene_transition()
