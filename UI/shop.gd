extends Control

@onready var v_box_container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer
#const BUILDING_PLACEMENT = preload("uid://fjg6m8jxharl")
const SHOP_ITEM: Resource = preload("uid://byw00vpoqkdyb")


var shop_items: Array[Panel]

func _ready() -> void:
	populate_shop()
	GameManager.shop_node = self

func populate_shop() -> void:
	access_items()
	
	var h_box: HBoxContainer
	
	for i: int in GameManager.buildings.size():
		
		# dynamically create an new hbox whenever a row of size 2 is full
		if i % 2 == 0:
			h_box = HBoxContainer.new()
			h_box.layout_direction = Control.LAYOUT_DIRECTION_LTR
			h_box.size_flags_horizontal = Control.SIZE_FILL
			h_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
			
			v_box_container.add_child(h_box)
			
		
		# test #2
		# instantiate the item
		var item: Node = SHOP_ITEM.instantiate()
		var building: Building = GameManager.buildings[i]
		if not building.purchased:
			item.get_node("PriceLabel").text = str(building.build_price) + " Goo"
			item.get_node("ItemIcon").texture = building.preview_image
			item.item_price = building.build_price
			item.building_path = building.prefab
			item.building_res = building
		else:
			item.get_node("PriceLabel").text = "Sold Out!"
			item.get_node("ItemIcon").texture = building.preview_image
			item.get_node("ItemIcon").modulate = Color(1, 0, 0)
			item.item_price = building.build_price
			item.building_path = building.prefab
			item.building_res = building
		
		# add the item to the correct h_box
		h_box.add_child(item)
		
		
		# shop item vars
		#var building_preview: Node2D
		#@export var item_price: float = 0.0
		#@export var building: Node2D
		#var building_path: PackedScene
		
		# building vars
		#@export var building_name: String
		#@export var description: String
		#@export var build_price: float
		#@export var preview_image: Texture2D
		#@export var prefab: PackedScene

func update_shop() -> void:
	access_items()
	for i: int in GameManager.buildings.size():
		var item: Panel = shop_items[i]
		var building: Building = GameManager.buildings[i]
		if building.purchased:
			item.get_node("PriceLabel").text = "Sold Out!"
			item.get_node("ItemIcon").texture = building.preview_image
			item.get_node("ItemIcon").modulate = Color(1, 0, 0)
			item.item_price = building.build_price
			item.building_path = building.prefab
			item.building_res = building

func access_items() -> void:
	shop_items = []
	for row: Node in v_box_container.get_children():
		for shop_item: Node in row.get_children():
			shop_items.append(shop_item)
			
