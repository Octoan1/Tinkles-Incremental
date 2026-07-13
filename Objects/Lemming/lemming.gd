extends CharacterBody2D



const SPEED = 150.0
#@export var health: float = 5.0
@export var death_value: float = 3.0
@export var damage_value: float = 1.0
@export var life_span: float = 30.0
var traits: Array[Trait]

#@onready var invuln_timer: Timer = $invuln_timer
@onready var lifespan_timer: Timer = $Lifespan
@onready var lemming_cam: Camera2D = $LemmingCam
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var click_timer: Timer = $click_timer
var click_ready = true
var some_cam_enabled = false
var jumping: bool = false

@onready var health_component: HealthComponent = $HealthComponent


#var invuln_duration: float = 0.5
#var invulnerable: bool = false

func _ready() -> void:
	#invuln_timer.wait_time = invuln_duration
	lifespan_timer.wait_time = life_span
	lifespan_timer.start()
	self.velocity.x = SPEED

func add_trait(t: Trait) -> void:
	print(t, " trait added")
	# check if trait already exists
	if traits.has(t):
		# special case: don't add trait if it is not stackable.
		if not t.stackable:
			return
	
	traits.append(t)
	assign_traits()

func assign_traits() -> void:
	for t in traits:
		self.call(t.effect_name)

#func take_damage(damage_amount) -> void:
	#if not invulnerable:
		#
		#
		#invulnerable = true
		#invuln_timer.start()
		#
		## calculate health_lost
		#var health_lost = health - damage_amount
		#if health_lost <= 0:
			#health_lost = health
		#else:
			#health_lost = health - (health - damage_amount)
		#
		#var total_goo = health_lost * damage_value
		#health -= damage_amount
		#
		#GameManager.modify_goo(total_goo)
		#
		#if health <= 0:
			#die()
		#else:
			#var pm: Node2D = get_tree().root.get_node("Main").get_node("ParticleManager")
			#pm.call_deferred("spawn_damage_particles", self.global_position, damage_amount)

#func die() -> void:
	#lemming_cam.enabled = false
	#GameManager.modify_goo(death_value)
	#
	## testing
	#get_tree().root.get_node("Main").get_node("ParticleManager").spawn_particles(self.global_position)
	#
	#self.queue_free()

func _physics_process(delta: float) -> void:
	if jumping: 
		sprite.rotate(3 * delta)
	
	
	if not is_on_floor(): 
		self.velocity += get_gravity() * 0.1
	
	if is_on_floor():
		self.velocity.x = move_toward(self.velocity.x, SPEED, delta)

	if self.velocity.x > 0:
		sprite.play("walk")
	else: 
		sprite.play("default")
		
	sprite.flip_h = self.velocity.x < 0

	move_and_slide()

func _input_event(_viewport: Viewport, event: InputEvent, _ignore: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_ready:
		if lemming_cam.enabled and click_ready:
			click_ready = false
			click_timer.start()
			disable_camera()
		elif event.pressed and click_ready:
			click_ready = false
			click_timer.start()
			inspect()

func inspect() -> void:
	get_tree().call_group("Lemming", "disable_camera")
	lemming_cam.enabled = true

func disable_camera() -> void:
	lemming_cam.enabled = false

func _on_ray_cast_2d_stopped_looking() -> void:
	# jump lemming
	self.velocity.y -= randf_range(1000, 1400)
	self.velocity.x += randf_range(100, 400)
	jumping = true
	

#func _on_invuln_timer_timeout() -> void:
	#invulnerable = false

func _on_lifespan_timeout() -> void:
	#die()
	health_component.kill()

func _on_click_timer_timeout() -> void:
	click_ready = true


### TRAITS HERE ###
func _fed() -> void:
	global_scale *= 1.5
	#health *= 2
	#health_component


func _on_health_component_died() -> void:
	lemming_cam.enabled = false
	GameManager.modify_goo(death_value)
	
	# testing
	#get_tree().root.get_node("Main").get_node("ParticleManager").spawn_particles(self.global_position)
	
	self.queue_free()


func _on_health_component_damaged(attack: Attack) -> void:
	var damage_amount = attack.attack_damage

	var total_goo = damage_amount * damage_value
	
	GameManager.modify_goo(total_goo)
	
	var pm: Node2D = get_tree().root.get_node("Main").get_node("ParticleManager")
	pm.call_deferred("spawn_damage_particles", self.global_position, damage_amount)
	
