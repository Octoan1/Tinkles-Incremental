extends CharacterBody2D



const SPEED = 150.0
@export var health: float = 5.0
@export var death_value: float = 3.0
@export var damage_value: float = 1.0
@export var life_span: float = 30.0

@onready var invuln_timer: Timer = $invuln_timer

var invuln_duration: float = 0.5
var invulnerable: bool = false

signal damage_taken(amount)
signal lemming_dead(amount)

func _ready():
	invuln_timer.wait_time = invuln_duration

func take_damage(damage_amount):
	if not invulnerable:
		invulnerable = true
		invuln_timer.start()
		
		var total_goo = damage_amount * damage_value
		emit_signal("damage_taken", total_goo)
		health -= damage_amount
		
		print(damage_amount, " health lost")

func die():
	emit_signal("lemming_dead", death_value)
	print("lemming dead")
	self.queue_free()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor(): 
		self.velocity += get_gravity() * 0.1
	
	self.velocity.x = SPEED

	move_and_slide()


func _on_ray_cast_2d_stopped_looking() -> void:
	# jump lemming
	self.velocity.y -= 1000


func _on_invuln_timer_timeout() -> void:
	invulnerable = false
