extends Area2D

signal entered()

export var scene := ""
export(SceneData.Type) var type := SceneData.Type.FORWARD

func _on_SceneArea2D_area_entered(area):
	_change_scene()


func _on_SceneArea2D_body_entered(body):
	_change_scene()


func _change_scene():
	emit_signal("entered")
	SceneManager.change_scene(scene, type)
