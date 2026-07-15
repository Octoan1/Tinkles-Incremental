extends Node2D

@export var attack_cooldown: float = 3.0

@onready var damage_area: Area2D = $DamageArea
@onready var attack_cooldown_timer: Timer = $attack_cooldown
@onready var crusher_trap: Sprite2D = $CrusherTrap
@onready var trap_start: Marker2D = $TrapStart
@onready var trap_end: Marker2D = $TrapEnd
var price = 10.0


var attacking = false
var resetting = false
var trap_speed = 500

func _ready() -> void:
	attack_cooldown_timer.start()

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
