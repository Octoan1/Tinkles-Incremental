extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()
	
	for button: TalentButton in $Panel/VBoxContainer/HBoxContainer.get_children():
		button.pressed.connect(_on_talent_button_pressed.bind(button))



func update_label() -> void:
	$Panel/VBoxContainer/Label.text = "Talent Points: %d / %d" % [TalentManager.talent_points, TalentManager.max_talent_points]	


func _on_talent_button_pressed(button: TalentButton) -> void:
	TalentManager.try_unlock(button.talent.name)
	update_label()
