extends CharacterBody2D


const SPEED = 150.0


func _physics_process(delta: float) -> void:
	
	if not is_on_floor(): 
		self.velocity += get_gravity() * 0.1
	
	self.velocity.x = SPEED

	move_and_slide()


func _on_ray_cast_2d_stopped_looking() -> void:
	# jump lemming
	self.velocity.y -= 1000
