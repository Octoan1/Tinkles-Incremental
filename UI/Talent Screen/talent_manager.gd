extends Node

var talent_points: int = -1
var max_talent_points: int = 3

var unlocked_talents: Dictionary[String, bool] = {}

func _ready() -> void:
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
			unlocked_talents[talent.name] = false
	
	debug_unlocked()
	
func debug_unlocked() -> void:
	print(unlocked_talents) 
	
func try_unlock(talent_name: String) -> bool:
	# already unlocked
	if unlocked_talents[talent_name]:
		debug_unlocked()
		return false 
	
	# no talent points to spend
	if talent_points <= 0:
		debug_unlocked()
		return false
		 
	# otherwise unlock
	unlock(talent_name)
	debug_unlocked()
	return true
	
func unlock(talent_name: String) -> void:
	unlocked_talents[talent_name] = true
	talent_points -= 1
