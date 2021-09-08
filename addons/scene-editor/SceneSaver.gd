tool
extends Node

const SAVE_FILE = "res://scene-editor.save"

export var graph_path: NodePath
onready var graph: GraphEdit = get_node(graph_path)

func load_data():
	if not _load_graph():
		graph.add_main_node()


func _load_graph() -> bool:
	var file = File.new()
	if file.file_exists(SAVE_FILE):
		var error = file.open(SAVE_FILE, File.READ)
		if error == OK:
			var data = file.get_var(true)
			if data:
				print(data)
				graph.load_data(data)
				return true
		else:
			push_error("Scene Editor: failed to load save file, %d" % error)
	return false
	
func save_data():
	var file = File.new()
	var error = file.open(SAVE_FILE, File.WRITE)
	if error == OK:
		var data = graph.get_data()
		if data:
			print(data)
			file.store_var(data, true)
	else:
		push_error("Scene Editor: failed to open save file, %d" % error)
