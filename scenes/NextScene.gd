extends Button

export var idx := 0

func _on_Next_pressed():
	SceneManager.next_scene(idx)
