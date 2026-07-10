extends Node2D

@export var Blood: PackedScene
@export var BloodParticlesCount: int = 50

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mb_left"):
		var color: Color = Color(randf(), randf(), randf())
		for i: int in range(BloodParticlesCount):
			var blood_instance : Area2D = Blood.instantiate()
			blood_instance.color = color
			blood_instance.global_position = get_global_mouse_position()
			add_child(blood_instance)
