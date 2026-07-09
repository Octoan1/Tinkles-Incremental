extends Area2D

@export var damage: int = 1
@export var delay: float = 1.0
@export var insta_kill: bool = false
@export var active: bool = true

func _ready():
	if active == true: self.monitoring = true
	else: self.monitoring = false

func _physics_process(delta: float) -> void:
	if active == true:
		for body in get_overlapping_bodies():
			if insta_kill == true:
				body.die()
			else:
				body.take_damage(damage)

func _on_body_entered(body: Node2D) -> void:
	if active == true:
		self.monitoring = true
	
