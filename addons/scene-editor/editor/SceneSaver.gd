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
				graph.load_data(data)
				return true
			file.close()
		else:
			push_error("Scene Editor: failed to load save file, %d" % error)
	return false
	
func save_data():
	var file = File.new()
	var error = file.open(SAVE_FILE, File.WRITE)
	if error == OK:
		var data = graph.get_data()
		if data:
			file.store_var(data, true)
		file.close()
	else:
		push_error("Scene Editor: failed to open save file, %d" % error)
	
	save_game_data()

func save_game_data():
	var file = File.new()
	var error = file.open(SceneData.GAME_SAVE_FILE, File.WRITE)
	if error != OK:
		push_error("Scene Editor: failed to open game save file, %d" % error)
		return
	
	var data := {}
	for conn in graph.get_connection_list():
		var from = graph.get_node(conn["from"])
		var to = graph.get_node(conn["to"])
		
		var from_scene = from.get_scene_path()
		var to_scene = to.get_scene_path()
		
		if not to_scene or not from_scene:
			add_scene_data(data, to_scene)
			add_scene_data(data, from_scene)
			continue
		
		add_scene_data(data, from_scene, {"scene": to_scene, "type": SceneData.Type.FORWARD})
		add_scene_data(data, to_scene, {"scene": from_scene, "type": SceneData.Type.BACK})
	
	var globals = []
	for node in graph.get_scene_nodes():
		var d = node.get_game_data()
		if d.has("global") and d["global"]:
			globals.append(d["scene"])
	
	for global in globals:
		for scene in data:
			if scene != global:
				add_scene_data(data, scene, {"scene": global, "type": SceneData.Type.GLOBAL})
	
	file.store_var(data)
	file.close()

func add_scene_data(data: Dictionary, scene: String, info: Dictionary = {}) -> void:
	if scene != null and scene != "" and not data.has(scene):
		data[scene] = []
	
	if info.keys().size() > 0 and not data[scene].has(info):
		data[scene].append(info)
