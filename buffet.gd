extends Node2D
const FED: Resource = preload("uid://c3jioqw4s0t18")
var price: float = 15.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.add_trait(FED)
