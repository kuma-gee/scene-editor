class_name SceneResource extends Resource

export var scene: PackedScene setget _set_scene

func _set_scene(s) -> void:
	scene = s
	emit_changed()
