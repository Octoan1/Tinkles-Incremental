extends Control

@onready var v_box_container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer
@onready var panel: Panel = $Panel

const UPGRADE_ITEM = preload("uid://bwujx2uaicury")
var upgrades: Array[BuildingUpgrade]
signal building_update(building: Building)

func _ready() -> void:
	pass

func populate_shop(building: Building) -> void:
	if not building:
		return
	upgrades = building.upgrades
	
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
			upgrade_ui.get_node("UpgradePriceButton").connect("pressed", upgrade_selected.bind(current_upgrade, building))
		# otherwise display unique max level ui
		else:
			upgrade_ui.get_node("UpgradeLevel").text = "LVL MAX"
			upgrade_ui.get_node("UpgradePriceButton").text = "SOLD OUT"
			upgrade_ui.get_node("UpgradePriceButton").disabled = true
			upgrade_ui.get_node("UpgradeIcon").modulate = Color(1, 0, 0)
			
		
		upgrade_ui.get_node("UpgradeIcon").texture = current_upgrade.upgrade_icon
		upgrade_ui.get_node("UpgradeName").text = current_upgrade.upgrade_name
		upgrade_ui.get_node("UpgradeDescription").text = current_upgrade.description
		
		
		
		# add the building upgrade to the v_box
		
		v_box_container.add_child(upgrade_ui)

func update_shop_ui() -> void:
	for i: int in v_box_container.get_children().size():
		var upgrade_ui: Node = v_box_container.get_child(i)
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
			upgrade_ui.get_node("UpgradePriceButton").disabled = true
			upgrade_ui.get_node("UpgradeIcon").modulate = Color(1, 0, 0)
			

func upgrade_selected(upgrade: BuildingUpgrade, building: Building) -> void:
	var upgrade_level: int = upgrade.upgrade_level
	var upgrade_cost: float = upgrade.level_cost[upgrade_level]
	if GameManager.goo >= upgrade_cost:
		if not upgrade.is_max_level:
			GameManager.goo -= upgrade_cost
			upgrade.upgrade_level += 1
			upgrade_building(building)
			
			if upgrade.upgrade_level >= 4:
				upgrade.is_max_level = true
			
			update_shop_ui()

# functionality to update building properties
func upgrade_building(building: Building) -> void:
	emit_signal("building_update", building)
