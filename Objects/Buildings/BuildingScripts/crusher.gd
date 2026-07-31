extends BuildingClass

@export var attack_cooldown: float = 3.0



@onready var crusher_trap: Sprite2D = $BuildingPivot/CrusherTrap
@onready var damage_area: Area2D = $BuildingPivot/DamageArea
@onready var attack_cooldown_timer: Timer = $BuildingPivot/attack_cooldown
@onready var trap_start: Marker2D = $BuildingPivot/TrapStart
@onready var trap_end: Marker2D = $BuildingPivot/TrapEnd


var price: float = 10.0


var attacking: bool = false
var resetting: bool = false
var trap_speed: float = 500
var base_trap_speed: float = 500
var base_cooldown: float = 3.0

func _physics_process(delta: float) -> void:
	if attacking:
		if crusher_trap.global_position.distance_to(trap_end.global_position) > 0.1:
			damage_area.monitoring = true
			
			damage_area.global_position.y = move_toward(damage_area.global_position.y, trap_end.global_position.y, trap_speed * delta)
			crusher_trap.global_position.y = move_toward(crusher_trap.global_position.y, trap_end.global_position.y, trap_speed * delta)
		else:
			attacking = false
			damage_area.monitoring = false
			resetting = true
			
			
	elif resetting:
		if crusher_trap.global_position.distance_to(trap_start.global_position) > 0.1:
			damage_area.global_position.y = move_toward(crusher_trap.global_position.y, trap_start.global_position.y, trap_speed * delta)
			crusher_trap.global_position.y = move_toward(crusher_trap.global_position.y, trap_start.global_position.y, trap_speed * delta)
		else:
			resetting = false
			attack_cooldown_timer.start()


func _on_attack_cooldown_timeout() -> void:
	attacking = true

func upgrade_building(building: Building) -> void:
	var upgrades: Array[BuildingUpgrade] = building.upgrades
	
	for upgrade: BuildingUpgrade in upgrades:
		if upgrade.upgrade_name == "Speed":
			# 50% increase each level
			trap_speed = base_trap_speed + (base_trap_speed * 0.5 * (upgrade.upgrade_level-1))
		elif upgrade.upgrade_name == "Cooldown":
			# 50% increase each level
			attack_cooldown = base_cooldown + (base_cooldown * 0.5 * (upgrade.upgrade_level-1))
	
