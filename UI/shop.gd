extends Control

@onready var v_box_container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer
const BUILDING_PLACEMENT = preload("uid://fjg6m8jxharl")

var shop_items: Array[Panel]

func _ready() -> void:
	populate_shop()

func populate_shop() -> void:
	access_items()
	for building in GameManager.buildings:
		#TODO complete logic
		pass


func access_items() -> void:
	shop_items = []
	for row in v_box_container.get_children():
		for shop_item in row.get_children():
			shop_items.append(shop_item)
			
