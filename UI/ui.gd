extends CanvasLayer

@onready var goo_label: Label = $GooLabel
@onready var talent_screen: Control = $TalentScreen

func _ready() -> void:
	goo_label.text = "Goo: " + str(GameManager.goo)
	GameManager.ui_node = self

func update_ui() -> void:
	goo_label.text = "Goo: " + str(GameManager.goo)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("talent_screen"):
		talent_screen.visible = !talent_screen.visible
