tool
class_name SceneGraph extends GraphEdit

signal open_scene(path)

const SCENE_NODE = preload("res://addons/scene-editor/editor/SceneNode.tscn")

func _ready():
	connect("connection_request", self, "connect_node")
	connect("disconnection_request", self, "disconnect_node")

func get_main_node() -> SceneNode:
	for child in get_children():
		if child is SceneNode and child.is_main_node():
			return child
	return null


func add_main_node():
	var node = _add_new_node("Main Scene")
	node.set_main_node()


func add_scene_node():
	_add_new_node()


func _get_node_count() -> int:
	return get_child_count() - 1 # Contains some CLAYER node


func _add_new_node(name := "") -> GraphNode:
	if name == "":
		name = "Scene %s" % _get_node_count()
	
	var node = SCENE_NODE.instance()
	node.title = "Scene"
	node.connect("close_request", self, "_close_node", [node])
	node.connect("open_scene", self, "_on_open_scene")
	
	
	add_child(node)
	node.name = name
	
	return node


func _close_node(node: Node) -> void:
	remove_child(node)


func _on_open_scene(path: String) -> void:
	emit_signal("open_scene", path)


func get_data() -> Dictionary:
	return {
		"nodes": _get_node_data(),
		"connections": get_connection_list()
	}

func _get_node_data(method = "get_data") -> Array:
	var nodes = []
	for node in get_children():
		if node.has_method(method):
			nodes.append(node.get_data())
	return nodes

func load_data(data: Dictionary) -> void:
	for node in data["nodes"]:
		_load_node(node)
	_load_connection_data(data["connections"])

func _load_node(node_data: Dictionary) -> void:
	var node = _add_new_node()
	node.load_data(node_data)

func _load_connection_data(connections: Array) -> void:
	for c in connections:
		connect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	
