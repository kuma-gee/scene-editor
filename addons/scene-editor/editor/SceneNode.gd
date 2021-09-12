tool
class_name SceneNode extends GraphNode

signal open_scene(path)

onready var name_label := $VBoxContainer/NameLabel
onready var open_button := $VBoxContainer/OpenScene

var resource := SceneResource.new()

func _ready():
	resource.connect("changed", self, "_update")
	_update()


func _on_SceneNode_resize_request(new_minsize):
	rect_size = new_minsize


func set_main_node() -> void:
	title = "Start"
	show_close = false


func is_main_node() -> bool:
	return not show_close


func get_scene_path() -> String:
	return resource.scene.resource_path if resource.scene else null

func get_scene_name() -> String:
	var path = get_scene_path()
	if path != null:
		var splits = path.split("/")
		if splits.size() > 0:
			return splits[splits.size() - 1]
	return ""

func _update():
	name_label.text = get_scene_name()
	open_button.disabled = resource.scene == null


func _on_OpenScene_pressed():
	emit_signal("open_scene", resource.scene.resource_path)

func get_game_data() -> Dictionary:
	var data = {
		"scene": get_scene_path(),
		"global": resource.global,
	}
	
	if is_main_node():
		data["main"] = true
	
	return data

func get_data() -> Dictionary:
	var data = get_game_data()
	data["offset"] = offset
	data["node_name"] = name
	return data

func load_data(data: Dictionary) -> void:
	name = data["node_name"]
	resource.scene = load(data["scene"]) if data["scene"] else null
	offset = data["offset"]
	resource.global = data["global"]
	
	if data.has("main") and data["main"]:
		set_main_node()
