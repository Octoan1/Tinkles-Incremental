extends RigidBody2D



@export var death_value: float = 3.0
@export var damage_value: float = 1.0
@export var life_span: float = 30.0
var traits: Array[Trait]

#@onready var invuln_timer: Timer = $invuln_timer
@onready var lifespan_timer: Timer = $Lifespan
@onready var lemming_cam: Camera2D = $LemmingCam
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var click_timer: Timer = $click_timer
var click_ready: bool = true
var some_cam_enabled: bool = false
var jumping: bool = false
var prev_vel: Vector2 = Vector2.ZERO

@onready var health_component: HealthComponent = $HealthComponent


#var invuln_duration: float = 0.5
#var invulnerable: bool = false

func _ready() -> void:
	#invuln_timer.wait_time = invuln_duration
	lifespan_timer.wait_time = life_span
	lifespan_timer.start()

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
	for t: Trait in traits:
		self.call(t.effect_name)


func _physics_process(_delta: float) -> void:
	prev_vel = linear_velocity
	
	if lemming_cam.enabled:
		print("pos: ", self.global_position)
		print("vel: ", self.linear_velocity)
		print("health: ", health_component.get_health())

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



func _on_lifespan_timeout() -> void:
	#die()
	health_component.kill()

func _on_click_timer_timeout() -> void:
	click_ready = true


### TRAITS HERE ###
func _fed() -> void:
	global_scale *= 1.5
	
	var max_health: float = health_component.get_max_health()
	health_component.set_max_health(max_health * 2)
	health_component.reset()
	#health *= 2
	#health_component


func _on_health_component_died() -> void:
	lemming_cam.enabled = false
	GameManager.modify_goo(death_value)
	
	# testing
	#get_tree().root.get_node("Main").get_node("ParticleManager").spawn_particles(self.global_position)
	
	self.queue_free()


func _on_health_component_damaged(attack: Attack) -> void:
	var damage_amount: float = attack.attack_damage

	var total_goo: float = damage_amount * damage_value
	
	GameManager.modify_goo(total_goo)
	
	var pm: Node2D = get_tree().root.get_node("Main").get_node("ParticleManager")
	pm.call_deferred("spawn_damage_particles", self.global_position, damage_amount)
	


func _on_body_entered(_body: Node) -> void:
	if prev_vel.length() > 700:
		var damage: float = prev_vel.length() / 100
		print(damage)
		health_component.apply_attack(Attack.new(damage))
