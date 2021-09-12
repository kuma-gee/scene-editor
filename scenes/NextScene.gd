extends Button

export(SceneData.Type) var type := SceneData.Type.FORWARD
export var scene := ""

func _ready():
	var _x = connect("pressed", self, "_on_Next_pressed")

func _on_Next_pressed():
	SceneManager.change_scene(scene, type)
