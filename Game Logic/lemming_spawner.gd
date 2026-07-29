extends Node2D

@export var scene: PackedScene

func _on_timer_timeout() -> void:
	create_lemming()

func create_lemming(pos: Vector2 = Vector2.ZERO) -> void:
	var lemming: Lemming = scene.instantiate()
	self.add_child(lemming)
	if pos:
		lemming.global_position = pos
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var event_key: InputEventKey = event
		if event_key.pressed and event_key.keycode == Key.KEY_1:
			create_lemming(get_global_mouse_position())
			
