extends Node2D

@export var scene: PackedScene

func _on_timer_timeout() -> void:
	var lemming: Node2D = scene.instantiate()
	
	self.add_child(lemming)
