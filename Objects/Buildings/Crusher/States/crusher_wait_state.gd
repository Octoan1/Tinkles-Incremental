extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var crusher: Node2D = $"../.."
@onready var return_state: Node = $"../Return"

func enter() -> void:
	animation_player.play("Wait")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Wait":
		switch_state.emit(return_state)
