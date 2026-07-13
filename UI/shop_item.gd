extends Panel
const BUILDING_PLACEMENT = preload("uid://fjg6m8jxharl")
@onready var item_icon: TextureRect = $ItemIcon
const BUFFET = preload("uid://dlayonr1hr4tv")


var building_preview: Node2D
var click_holding = false
var can_place = false
@export var item_price: float = 0.0
@export var building: Node2D
var building_path: PackedScene

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		# create the building preview while holding lmb
		if event.pressed and not click_holding:
			click_holding = true
			
			building_preview = BUILDING_PLACEMENT.instantiate()
			
			building_preview.sprite = item_icon.texture
			building_preview.global_position = get_global_mouse_position()
			building_preview.connect("valid_placement", can_place_building)
			get_tree().current_scene.add_child(building_preview)
			
			item_icon.modulate.a = 0.5
			can_place = false
		
		# check when mouse is released
		elif not event.pressed and click_holding:
			click_holding = false
			
			# if the building can be purchased, place it and reset preview
			if GameManager.goo >= item_price and can_place:
				# update goo
				GameManager.goo -= item_price
				
				# currently hardcoded to build the buffet
				building = BUFFET.instantiate()
				#building = building_path.instantiate()
				
				building.global_position = get_global_mouse_position()
				get_tree().current_scene.add_child(building)
				
				print("building purchased!")
				
				if is_instance_valid(building_preview):
					building_preview.queue_free()
				can_place = false
				
			# if the building cannot be placed, reset preview
			else:
				if is_instance_valid(building_preview):
					building_preview.queue_free()
				print("building failed to purchase")
			
			item_icon.modulate.a = 1.0
			can_place = false
		

func can_place_building() -> void:
	can_place = true

# check if lmb is held down, and if the building preview exists
func _process(delta: float) -> void:
	if click_holding and is_instance_valid(building_preview):
		building_preview.global_position = get_global_mouse_position()
