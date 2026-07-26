extends Button
class_name TalentButton

@export var talent: Talent

var has_been_pressed: bool = false:
	set(value): 
		has_been_pressed = value
		disabled = has_been_pressed
		
func _ready() -> void:
	text = talent.name
	icon = talent.icon
