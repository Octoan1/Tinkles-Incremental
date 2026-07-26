extends Control

var buttons: Array[TalentButton]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()
	
	for button: TalentButton in $Panel/VBoxContainer/HBoxContainer.get_children():
		button.pressed.connect(_on_talent_button_pressed.bind(button))
		buttons.append(button)
		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("talent_reset"):
		TalentManager.reset_talents()
		update_label()
		for button: TalentButton in buttons:
			button.disabled = false

func update_label() -> void:
	$Panel/VBoxContainer/Label.text = "Talent Points: %d / %d" % [TalentManager.talent_points, TalentManager.max_talent_points]	


func _on_talent_button_pressed(button: TalentButton) -> void:
	if TalentManager.try_activate(button.talent.name):
		button.disabled = true
	update_label()
	
	if TalentManager.talent_points == 0:
		disable_buttons()
		
func disable_buttons() -> void:
	for button: TalentButton in buttons:
		button.disabled = true
