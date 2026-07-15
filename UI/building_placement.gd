extends Node2D

@onready var texture_rect: TextureRect = $TextureRect
var sprite: Texture2D
@onready var area_2d: Area2D = $Area2D
signal valid_placement

func _ready() -> void:
	texture_rect.texture = sprite

func _process(_delta: float) -> void:
	var areas: Array[Area2D] = area_2d.get_overlapping_areas()
	if not areas.is_empty():
		emit_signal("valid_placement", true)
	else:
		emit_signal("valid_placement", false)
