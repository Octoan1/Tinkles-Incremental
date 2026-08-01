extends Node2D

func _ready() -> void:
	GameManager.building_spawner = self
	GameManager.rebuild_scene()
