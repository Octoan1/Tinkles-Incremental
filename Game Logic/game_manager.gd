extends Node

var goo: float = 0.0
var ui_node: CanvasLayer
var buildings: Array[Building]

func _ready() -> void:
	var folder_path = "res://Objects/Buildings/"
	var files = DirAccess.get_files_at(folder_path)
	
	for file_name in files:
		if file_name.ends_with(".import") or file_name.ends_with(".remap"):
			continue
		
		var full_path = folder_path + file_name
		
		var resource = load(full_path)
		if resource is Building:
			buildings.append(resource)

func modify_goo(amount):
	goo += amount
	ui_node.update_ui()
