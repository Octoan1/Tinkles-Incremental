extends Node2D
class_name BuildingClass

@export var building_node: Node2D
@export var building_cam: Camera2D
@export var click_area: Area2D
var building_res: Building

var click_timer: Timer
var click_ready: bool = true

const BUILDING_UPGRADE_SHOP = preload("uid://c6y0a8dck4dip")
var building_shop_node: Control

func _ready() -> void:
	click_timer = Timer.new()
	add_child(click_timer)
	click_timer.wait_time = 0.1
	click_timer.connect("timeout", _on_click_timer_timeout)
	
	click_area.connect("input_event", _on_click_area_input_event)
	
	


func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_ready:
		print("Building selected")
		if building_cam.enabled and click_ready:
			click_ready = false
			click_timer.start()
			disable_camera()
		elif event.pressed and click_ready:
				click_ready = false
				click_timer.start()
				inspect()
				

# create a building group!
func inspect() -> void:
	get_tree().call_group("Building", "disable_camera")
	get_tree().call_group("Lemming", "disable_camera")
	building_cam.enabled = true
	print("Inspecting building")
	
	# spawn the upgrade shop
	# how to safely reference the resource?
	building_shop_node = BUILDING_UPGRADE_SHOP.instantiate()
	get_tree().current_scene.find_child("UI").add_child(building_shop_node)
	building_shop_node.populate_shop(building_res)
	
	
	
	
	
	

func disable_camera() -> void:
	building_cam.enabled = false
	if building_shop_node:
		building_shop_node.queue_free()

func _on_click_timer_timeout() -> void:
	click_ready = true
