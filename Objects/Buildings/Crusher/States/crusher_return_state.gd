extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: Node = $"../Idle"

func enter() -> void:
	animation_player.play("Return")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Return":
		switch_state.emit(idle)
