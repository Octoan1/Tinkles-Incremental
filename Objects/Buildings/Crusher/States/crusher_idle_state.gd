extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var crusher: Node2D = $"../.."
@onready var slam: Node = $"../Slam"
@onready var attack_cooldown: Timer = $AttackCooldown


func enter() -> void:
	#animation_player.play("Idle")
	await get_tree().create_timer(crusher.attack_cooldown).timeout
	switch_state.emit(slam)


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "Idle":
		#switch_state.emit(slam)
