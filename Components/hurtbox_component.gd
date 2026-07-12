extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent

func _ready() -> void:
	self.monitoring = false
	self.monitorable = true
	
	assert(health_component, "HurtboxComponent requires a HealthComponent.")
	

func receive_attack(attack: Attack) -> void:
	if health_component:
		health_component.apply_attack(attack)
	
