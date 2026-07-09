extends RayCast2D

signal looking_at(target: Node)
signal stopped_looking()

var wasLooking : bool = false
func _process(_delta: float) -> void:
	var collider: CollisionObject2D = get_collider()
	if collider:
		wasLooking = true
		var new_target : Node = collider.get_owner()
		looking_at.emit(new_target)
		#print("Looking at: ",new_target)
	elif wasLooking:
		wasLooking = false
		stopped_looking.emit()
		#print("Stopped looking")
