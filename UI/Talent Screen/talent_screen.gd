extends Control

@export var talent_points: int = 3:
	set(value):
		talent_points = value
		update_label()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()
	
	for button: Button in $Panel/VBoxContainer/HBoxContainer.get_children():
		button.pressed.connect(_on_talent_button_pressed.bind(button))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_label() -> void:
	$Panel/VBoxContainer/Label.text = "Talent Points: %d" % [talent_points]	


func _on_talent_button_pressed(button: Button) -> void:
	if button.has_been_pressed: 
		return
	
	if talent_points > 0: 
		talent_points -= 1
		button.has_been_pressed = true
