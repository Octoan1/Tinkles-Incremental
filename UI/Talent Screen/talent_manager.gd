extends Node

var talent_points: int = -1
var max_talent_points: int = 3

var active_talents: Dictionary[String, bool] = {}

func _ready() -> void: 
	populate_unlock_dictionary()
	debug_active()
	
func populate_unlock_dictionary() -> void:
	talent_points = max_talent_points
	
	var folder_path: String = "res://UI/Talent Screen/Talents/"
	var files: PackedStringArray = DirAccess.get_files_at(folder_path)
	
	for file_name: String in files:
		if not file_name.ends_with(".tres"):
			continue
		
		var full_path: String = folder_path + file_name
		
		var resource: Resource = load(full_path)
		if resource is Talent:
			var talent: Talent = resource
			active_talents[talent.name] = false

func debug_active() -> void:
	print(active_talents) 
	
func try_activate(talent_name: String) -> bool:
	# already unlocked
	if active_talents[talent_name]:
		debug_active()
		return false 
	
	# no talent points to spend
	if talent_points <= 0:
		debug_active()
		return false
		 
	# otherwise unlock
	activate(talent_name)
	debug_active()
	return true
	
func activate(talent_name: String) -> void:
	active_talents[talent_name] = true
	talent_points -= 1
	
func reset_talents() -> void:
	for talent_name: String in active_talents:
		active_talents[talent_name] = false
	talent_points = max_talent_points
	debug_active()
