extends State

@onready var lemming: RigidBody2D = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export_category("Configuration")
@export var speed: float = 300
@export_category("Next States")
@export var jump_state: State

func enter() -> void:
	sprite.play("walk")


func physics_update(_delta: float) -> void:
	lemming.linear_velocity.x = speed


func _on_jump_detection_ray_cast_stopped_looking() -> void:
	switch_state.emit(jump_state)
