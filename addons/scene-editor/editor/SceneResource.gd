class_name SceneResource extends Resource

export var scene: PackedScene setget _set_scene
export var transition := true

func _set_scene(s) -> void:
	scene = s
	emit_changed()
