extends CharacterBody2D



const SPEED = 150.0
@export var health: float = 5.0
@export var death_value: float = 3.0
@export var damage_value: float = 1.0
@export var life_span: float = 30.0
var traits: Array[Trait]

@onready var invuln_timer: Timer = $invuln_timer

var invuln_duration: float = 0.5
var invulnerable: bool = false

func _ready() -> void:
	invuln_timer.wait_time = invuln_duration
	self.velocity.x = SPEED

func add_trait(t: Trait) -> void:
	print(t, " trait added")
	# check if trait already exists
	if traits.has(t):
		# special case: Fed can be stacked.
		if t.name != "Fed":
			return
	
	traits.append(t)
	assign_traits()

func assign_traits() -> void:
	for t in traits:
		self.call(t.effect_name)

func take_damage(damage_amount) -> void:
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
	
	if is_on_floor():
		self.velocity.x = move_toward(self.velocity.x, SPEED, delta)

	move_and_slide()


func _on_ray_cast_2d_stopped_looking() -> void:
	# jump lemming
	self.velocity.y -= randf_range(1000, 1400)
	self.velocity.x += randf_range(100, 400)


func _on_invuln_timer_timeout() -> void:
	invulnerable = false


### TRAITS HERE ###

func _fed() -> void:
	global_scale *= 1.5
	health *= 2
