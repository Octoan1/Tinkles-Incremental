extends Node
class_name HealthComponent

signal died
signal damaged(attack: Attack)
signal health_changed(current_health: float, max_health: float)
signal invulnerability_started
signal invulnerability_ended

# general
@export var debug_mode: bool = false
# object specfic
@export var max_health: float = 10
@export var invulnerability_duration: float = 0.5
#@export var defense_component: DefenseComponent

var _health: float
var is_invulnerable: bool = false
var invuln_timer: Timer


func _ready() -> void:
	_health = max_health
	
	invuln_timer = Timer.new()
	invuln_timer.wait_time = invulnerability_duration
	invuln_timer.one_shot = true
	invuln_timer.timeout.connect(_on_invuln_timer_timeout)
	self.add_child(invuln_timer)

#region PUBLIC API	

## Gets the current health amount
func get_health() -> float:
	return _health


## Sets the health 
func set_health(amount: float) -> void:
	_health = amount
	health_changed.emit(_health, max_health) 


## Gets the current max health amount
func get_max_health() -> float:
	return max_health


## Sets the max health 
func set_max_health(amount: float) -> void:
	max_health = amount
	health_changed.emit(_health, max_health) 


## Apply an [param attack] on the entity, returns false if the entity is 
## currently invulnerable
## [br][br]
## See [Attack] for information on an attack object	
func apply_attack(attack: Attack) -> bool:
	if is_invulnerable:
		if debug_mode:
			print(owner.name + " is invulnerable right now")
		return false
	
	#if defense_component:
		#attack_damage = defense_component.modify_damage(attack_damage)
		#if attack_damage <= 0:
			#return false
	
	_health -= attack.attack_damage
	_health = max(_health, 0)
	
	if debug_mode:
		print(owner.name, " health: ", _health)
		
	damaged.emit(attack)
	health_changed.emit(_health, max_health)
	
	# death 
	if _health == 0:
		died.emit()
		return true
	
	# give slight invulnerability upon taking damage
	if invulnerability_duration > 0:
		start_invulnerability()
	
	return true
	
	
## Directly modify the health of an entity by the given [param amount]
func modify_health(amount: float) -> void:
	_health += amount
	_health = clamp(_health, 0, max_health)
	
	health_changed.emit(_health, max_health)
	
	# death
	if _health == 0:
		died.emit()
	
## Sets [member _health] to 0 ands makes entity die
func kill() -> void:
	_health = 0
	health_changed.emit(_health, max_health)
	died.emit()


## Resets the health component to its base state in [method _ready]
func reset() -> void:
	_health = max_health
	is_invulnerable = false
	invuln_timer.stop()


## Starts the on damage invulnerability timer, 
func start_invulnerability() -> void:
	is_invulnerable = true
	invulnerability_started.emit()
	invuln_timer.start()

#endregion

#region PRIVATE

func _on_invuln_timer_timeout() -> void:
	is_invulnerable = false
	invulnerability_ended.emit()
	
#endregion 
