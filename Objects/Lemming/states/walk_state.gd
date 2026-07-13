extends State

@export var entity: RigidBody2D
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export_category("Configuration")
@export var speed: float = 300

func enter() -> void:
	sprite.play("walk")


func physics_update(_delta: float) -> void:
	entity.linear_velocity.x = speed


func _on_jump_detection_ray_cast_stopped_looking() -> void:
	entity.lock_rotation = false
	entity.apply_impulse(Vector2(100,-400), entity.global_position + Vector2(-1,0))
	entity.angular_velocity = 2
