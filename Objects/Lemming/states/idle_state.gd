extends State

@onready var walk: State  = $"../Walk"
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"


func enter() -> void:
	sprite.play("eating")
	get_tree().create_timer(1).timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout() -> void:
	switch_state.emit(walk)
