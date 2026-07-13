extends State

@onready var lemming: RigidBody2D = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export_category("Configuration")
@export var speed: float = 300
@export_category("Next States")
@export var fall_state: State


func enter() -> void:
	lemming.lock_rotation = false
	lemming.apply_impulse(Vector2(100,-400), lemming.global_position + Vector2(-1,0))
	lemming.angular_velocity = 2
	
func physics_update(_delta: float) -> void:
	if lemming.linear_velocity.y > 0:
		switch_state.emit(fall_state)
