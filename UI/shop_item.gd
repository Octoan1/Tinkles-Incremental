extends Panel
const BUILDING_PLACEMENT: Resource = preload("uid://fjg6m8jxharl")
@onready var item_icon: TextureRect = $ItemIcon
const BUFFET: Resource = preload("uid://dlayonr1hr4tv")


var building_preview: Node2D
var click_holding: bool = false
var can_place: bool = false
@export var item_price: float = 0.0
@export var building: Node2D
var building_path: PackedScene

func _gui_input(event: InputEvent) -> void:
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
			
			if is_instance_valid(building_preview) and building_preview.is_connected("valid_placement", can_place_building):
				building_preview.disconnect("valid_placement", can_place_building)
			
			# if the building can be purchased, place it and reset preview
			if GameManager.goo >= item_price and can_place:
				# update goo and ui
				GameManager.modify_goo(-item_price)
				
				building = building_path.instantiate()
				
				var mouse_pos: Vector2 = get_global_mouse_position()
				var tile_map: TileMapLayer = get_tree().current_scene.find_child("BuildingPlacement")
				var tile_coords: Vector2 = tile_map.local_to_map(tile_map.to_local(mouse_pos))
				var tile_global_pos: Vector2 = tile_map.to_global(tile_map.map_to_local(tile_coords))
				
				building.global_position = tile_global_pos
				
				#building.global_position = get_global_mouse_position()
				get_tree().current_scene.add_child(building)
				
				print("building purchased!")
				
				if is_instance_valid(building_preview):
					building_preview.queue_free()
				can_place = false
				
			elif not can_place:
				if is_instance_valid(building_preview):
					building_preview.queue_free()
				print("Invalid Placement Location")
			# if the building cannot be placed, reset preview
			elif GameManager.goo < item_price:
				if is_instance_valid(building_preview):
					building_preview.queue_free()
				print("Not enough goo!")
			else:
				if is_instance_valid(building_preview):
					building_preview.queue_free()
				print("Error. This should not be possible")
			
			item_icon.modulate.a = 1.0
			can_place = false
		

func can_place_building(place: bool) -> void:
	can_place = place

# check if lmb is held down, and if the building preview exists
func _process(_delta: float) -> void:
	if click_holding and is_instance_valid(building_preview) and can_place:
			var mouse_pos: Vector2 = get_global_mouse_position()
			var tile_map: TileMapLayer = get_tree().current_scene.find_child("BuildingPlacement")
			var tile_coords: Vector2 = tile_map.local_to_map(tile_map.to_local(mouse_pos))
			var tile_global_pos: Vector2 = tile_map.to_global(tile_map.map_to_local(tile_coords))
			
			building_preview.global_position = tile_global_pos
	elif click_holding and is_instance_valid(building_preview):
		building_preview.global_position = get_global_mouse_position()
