tool
extends EditorPlugin

const DOCK_SCENE = preload("res://addons/scene-editor/editor/SceneEditor.tscn")
const SCENE_MANAGER = "res://addons/scene-editor/SceneManager.tscn"

var dock

func _ready():
	connect("resource_saved", self, "_on_resource_saved")


func _on_resource_saved(resource: Resource) -> void:
	if dock:
		dock.save()


func _enter_tree():
	dock = DOCK_SCENE.instance()
	dock.interface = get_editor_interface()
	add_control_to_bottom_panel(dock, "Scene Editor")
	
	# TODO: only add if not existing
	add_autoload_singleton("SceneManager", SCENE_MANAGER)

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
	
