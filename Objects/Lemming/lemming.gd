extends CharacterBody2D



const SPEED = 150.0
@export var health: float = 5.0
@export var death_value: float = 3.0
@export var damage_value: float = 1.0
@export var life_span: float = 30.0
var traits: Array[String]

@onready var invuln_timer: Timer = $invuln_timer

var invuln_duration: float = 0.5
var invulnerable: bool = false

func _ready():
	invuln_timer.wait_time = invuln_duration

func take_damage(damage_amount):
	if not invulnerable:
		invulnerable = true
		invuln_timer.start()
		
		# calculate health_lost
		var health_lost = health - damage_amount
		if health_lost <= 0:
			health_lost = health
		else:
			health_lost = health - (health - damage_amount)
		
		var total_goo = health_lost * damage_value
		health -= damage_amount
		
		GameManager.modify_goo(total_goo)
		
		if health <= 0:
			die()

func die():
	GameManager.modify_goo(death_value)
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
