tool
extends Control

onready var graph := $SceneGraph
onready var saver := $SceneSaver

var interface: EditorInterface

func _ready():
	saver.load_data()

func save():
	var main = graph.get_main_node()
	if main != null:
		var scene = main.get_scene_path()
		if scene == null:
			scene = ""
		_set_default_scene(scene)
	saver.save_data()


func _set_default_scene(scene: String):
	ProjectSettings.set_setting("application/run/main_scene", scene)


func _on_Button_pressed():
	graph.add_scene_node()


func _on_SceneGraph_open_scene(path):
	interface.open_scene_from_path(path)


func _on_SceneGraph_node_selected(node):
	interface.edit_resource(node.resource)
