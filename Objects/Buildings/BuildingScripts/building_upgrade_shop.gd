extends Control

@onready var v_box_container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer
@onready var panel: Panel = $Panel

const UPGRADE_ITEM = preload("uid://bwujx2uaicury")

func _ready() -> void:
	pass

func populate_shop(building: Building) -> void:
	if not building:
		return
	var upgrades: Array[BuildingUpgrade] = building.upgrades
	
	panel.get_node("BuildingName").text = building.building_name
	panel.get_node("BuildingIcon").texture = building.preview_image
	panel.get_node("BuildingDescription").text = building.description
	
	for i: int in upgrades.size():
		var upgrade_ui: Node = UPGRADE_ITEM.instantiate()
		var current_upgrade: BuildingUpgrade = upgrades[i]
		var current_level: int = current_upgrade.upgrade_level
		
		upgrade_ui.get_node("UpgradeIcon").texture = current_upgrade.upgrade_icon
		
		# display upgrade data if not max level
		if not current_upgrade.is_max_level:
			upgrade_ui.get_node("UpgradeLevel").text = "LVL " + str(current_level)
			upgrade_ui.get_node("UpgradePriceButton").text = str(current_upgrade.level_cost[current_level]) + " Goo"
		# otherwise display unique max level ui
		else:
			upgrade_ui.get_node("UpgradeLevel").text = "LVL MAX"
			upgrade_ui.get_node("UpgradePriceButton").text = "SOLD OUT"
			upgrade_ui.get_node("UpgradeIcon").modulate = Color(1, 0, 0)
			
		
		upgrade_ui.get_node("UpgradeIcon").texture = current_upgrade.upgrade_icon
		upgrade_ui.get_node("UpgradeName").text = current_upgrade.upgrade_name
		upgrade_ui.get_node("UpgradeDescription").text = current_upgrade.description
		
		# add the building upgrade to the v_box
		v_box_container.add_child(upgrade_ui)
