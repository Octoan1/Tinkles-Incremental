extends Node

# added to fix git changes
var goo: float = 0.0
var ui_node: CanvasLayer
var buildings: Array[Building] = []
var shop_node: Control
var building_spawner: Node2D

func _ready() -> void:
	load_game()
	print(buildings)

func rebuild_scene() -> void:
	if not is_instance_valid(building_spawner):
		return
	
	
	for b: Building in buildings:
		if b.purchased:
			print(b, b.placement)
			var instance: Node2D = b.prefab.instantiate()
			instance.position = b.placement
			instance.building_res = b
			# apply building upgrades
			instance.upgrade_building(b)
			building_spawner.add_child(instance)
	

# for new game
func load_default_buildings() -> void:
	var folder_path: String = "res://Objects/Buildings/BuildingResources/"
	var files: PackedStringArray = DirAccess.get_files_at(folder_path)
	
	for file_name: String in files:
		if file_name.ends_with(".tres"):
			var full_path: String = folder_path + file_name
			var raw_res: Resource = load(full_path)
			
			if raw_res is Building:
				
				var b_res: Building = raw_res.duplicate()
				b_res.set_meta("saved_disk_path", full_path)
				
				
				var fresh_upgrades: Array[BuildingUpgrade] = []
				for up: BuildingUpgrade in b_res.upgrades:
					fresh_upgrades.append(up.duplicate())
				b_res.upgrades = fresh_upgrades
				buildings.append(b_res)
			
			#var resource: Resource = load(full_path)
			#if resource is Building:
				#buildings.append(resource)

func modify_goo(amount: float) -> void:
	goo += amount
	ui_node.update_ui()
	save_game()

func update_shop() -> void:
	shop_node.update_shop()


func save_game() -> void:
	var buildings_data: Array = []
	
	for b: Building in buildings:
		var upgrades_data: Array[Dictionary] = []
		
		# collect all of the upgrade data for the building
		for up: BuildingUpgrade in b.upgrades:
			var upgrade_dict: Dictionary = {
				"level": up.upgrade_level,
				"is_max": up.is_max_level,
			}
			upgrades_data.append(upgrade_dict)
		
		var true_path: String = b.get_meta("saved_disk_path", b.resource_path)
		
		# save all of the building data
		var building_dict: Dictionary = {
			"resource_path": true_path,
			"upgrades": upgrades_data,
			"purchased": b.purchased,
			"placement": b.placement
		}
		buildings_data.append(building_dict)
	
	
	var save_dict: Dictionary = {
		"goo" : goo,
		"buildings" : buildings_data
	}
	
	var file: FileAccess = FileAccess.open("user://data.save", FileAccess.WRITE)
	file.store_var(save_dict)
	file.close()

func load_game() -> void:
	buildings.clear()
	
	if not FileAccess.file_exists("user://data.save"):
		load_default_buildings()
		return
	
	var file: FileAccess = FileAccess.open("user://data.save", FileAccess.READ)
	var data: Variant = file.get_var()
	file.close()
	
	if not data is Dictionary:
		load_default_buildings()
		return
	
	goo = data.get("goo", 0.0)
	if data.has("buildings") and data.get("buildings").size() > 0:
		var saved_buildings = data.get("buildings")
		
		for b_data in saved_buildings:
			if not b_data is Dictionary:
				continue
			
			var path: String = b_data.get("resource_path", "")
			
			if path == "" or not ResourceLoader.exists(path):
				continue
			
			var b_res: Resource = load(path).duplicate()
			
			if b_res is Building:
				b_res.set_meta("saved_disk_path", path)
				
				b_res.purchased = b_data.get("purchased", false)
				b_res.placement = b_data.get("placement", Vector2.ZERO)
				
				var fresh_upgrades: Array[BuildingUpgrade] = []
				for up: BuildingUpgrade in b_res.upgrades:
					fresh_upgrades.append(up.duplicate())
				b_res.upgrades = fresh_upgrades
				
				if b_data.has("upgrades"):
					var saved_upgrades = b_data.get("upgrades")
					
					for i in range(saved_upgrades.size()):
						if i < b_res.upgrades.size():
							var up_data = saved_upgrades[i]
							var up_res = b_res.upgrades[i]
							
							up_res.upgrade_level = up_data.get("level", 1)
							up_res.is_max_level = up_data.get("is_max", false)
				
				buildings.append(b_res)
	else:
		load_default_buildings()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("delete_save_debug"):
		_reset_save_data()

# DEBUG
func _reset_save_data() -> void:
	print(is_instance_valid(building_spawner))
	if is_instance_valid(building_spawner):
		print(building_spawner.get_children())
		for child in building_spawner.get_children():
			child.free()
	
	get_tree().call_group("Lemming", "free")
	
	buildings.clear()
	goo = 0.0
	if FileAccess.file_exists("user://data.save"):
		var error: Error = DirAccess.remove_absolute("user://data.save")
		if error != OK:
			print("Warning: Could not delete save file. Error code: ", error)
	load_default_buildings()
	save_game()
	
	if ui_node:
		ui_node.update_ui()
	update_shop()
