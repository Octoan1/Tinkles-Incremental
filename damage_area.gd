extends Area2D

@export var damage: int = 1
@export var delay: float = 1.0
@export var insta_kill: bool = false
@export var active: bool = true
@export var one_shot: bool = false

func _ready() -> void:
	#if active == true: self.monitoring = true
	#else: self.monitoring = false
	pass

func _physics_process(_delta: float) -> void:
	#if active == true and one_shot == false:
		#for body in get_overlapping_bodies():
			#if insta_kill == true:
				#body.die()
			#else:
				#body.take_damage(damage)
	pass

func _on_body_entered(_body: Node2D) -> void:
	#if active == true and one_shot == true:
		#body.take_damage(damage)
	pass
