extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var slam: Node = $"../Slam"


func enter() -> void:
	animation_player.play("Idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Idle":
		switch_state.emit(slam)
