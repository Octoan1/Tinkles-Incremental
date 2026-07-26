extends Resource
class_name Building

@export var building_name: String
@export var description: String
@export var build_price: float
@export var preview_image: Texture2D
@export var prefab: PackedScene
@export var purchased: bool = false
# dictionary containing building upgrades
# each upgrade name will be the key
# the values will contain the upgrade's current level, cost, and if it is maxed
# ex: crusher_speed = (1, 50.0, false), crusher_cooldown = (2, 150.0, false)
@export var upgrades: Array[BuildingUpgrade]
