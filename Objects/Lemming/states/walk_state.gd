extends State

@export var entity: RigidBody2D
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export_category("Configuration")
@export var speed: float = 300

func enter() -> void:
	sprite.play("walk")

func physics_update(_delta: float) -> void:
	entity.linear_velocity.x = speed
