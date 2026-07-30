extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var wait: Node = $"../Wait"

func enter() -> void:
	animation_player.play("Slam")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Slam":
		switch_state.emit(wait)
