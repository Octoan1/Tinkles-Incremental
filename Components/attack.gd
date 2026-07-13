extends Resource
class_name Attack

@export var attack_damage: float
@export var knockback_force: float


func _init(damage: float = 1.0, knockback: float = 0) -> void:
	attack_damage = damage
	knockback_force = knockback
