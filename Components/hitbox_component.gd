extends Area2D
class_name HitboxComponent

signal hit_something(hurtbox: HurtboxComponent)

@export var debug_mode: bool = false
@export var attack: Attack


func _ready() -> void:
	self.monitoring = true
	self.monitorable = false
	
	if not attack:
		attack = Attack.new()


func _physics_process(_delta: float) -> void:
	if not monitoring:
		return
	
	for area: Area2D in get_overlapping_areas():
		if area is HurtboxComponent:	
			var hurtbox : HurtboxComponent = area
			
			if debug_mode:
				print(hurtbox.name + " - owned by: " + hurtbox.owner.name)
				
			hurtbox.receive_attack(attack)
			hit_something.emit(hurtbox)
