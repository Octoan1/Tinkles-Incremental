extends Resource
class_name BuildingUpgrade
# basic upgrade info
@export var upgrade_name: String
@export var upgrade_icon: Texture2D
@export var description: String
# upgrades start at level 1 for simplicity (as opposed to 0)
@export var upgrade_level: int = 1
# current_level : cost_to_upgrade
@export var level_cost: Dictionary[int, float] = {
	1: 50.0,
	2: 150.0,
	3: 350.0
}
@export var is_max_level: bool
