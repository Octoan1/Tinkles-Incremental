extends Node2D

@onready var texture_rect: TextureRect = $TextureRect
var sprite: Texture2D
@onready var area_2d: Area2D = $Area2D
signal valid_placement
var placement = false
var old_placement = true

func _ready() -> void:
	texture_rect.texture = sprite

func _process(delta: float) -> void:
	
	var tilemap = area_2d.get_overlapping_bodies()
	if not tilemap.is_empty() and old_placement == false:
		texture_rect.modulate = Color(0,1,0)
		emit_signal("valid_placement", true)
		old_placement = true
	elif tilemap.is_empty() and old_placement == true:
		texture_rect.modulate = Color(1,0,0)
		emit_signal("valid_placement", false)
		old_placement = false
	
	
	#var areas = area_2d.get_overlapping_areas()
	#if not areas.is_empty():
		#emit_signal("valid_placement", true)
	#else:
		#emit_signal("valid_placement", false)
