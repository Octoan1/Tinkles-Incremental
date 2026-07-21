extends CanvasLayer

@onready var goo_label: Label = $GooLabel

func _ready() -> void:
	goo_label.text = "Goo: " + str(GameManager.goo)
	GameManager.ui_node = self

func update_ui() -> void:
	goo_label.text = "Goo: " + str(GameManager.goo)
