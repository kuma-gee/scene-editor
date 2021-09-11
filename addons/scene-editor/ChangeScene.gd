extends Area2D

export var scene := ""

func _on_SceneArea2D_area_entered(area):
	_change_scene()


func _on_SceneArea2D_body_entered(body):
	_change_scene()


func _change_scene():
	SceneManager.change_scene(scene)
