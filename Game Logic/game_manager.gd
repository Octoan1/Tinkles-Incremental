extends Node

# added to fix git changes
var goo: float = 0.0
var ui_node: CanvasLayer
var buildings: Array[Building]
var shop_node: Control

func _ready() -> void:
	var folder_path: String = "res://Objects/Buildings/"
	var files: PackedStringArray = DirAccess.get_files_at(folder_path)
	
	for file_name: String in files:
		if file_name.ends_with(".import") or file_name.ends_with(".remap"):
			continue
		
		var full_path: String = folder_path + file_name
		
		var resource: Resource = load(full_path)
		if resource is Building:
			buildings.append(resource)

func modify_goo(amount: float) -> void:
	goo += amount
	ui_node.update_ui()

func update_shop() -> void:
	shop_node.update_shop()
