extends Node
class_name StateMachine

@export var debug_mode: bool = false

@export var initial_state: State

var active_state: State

func _ready() -> void:
	for child_state: State in get_children():
		child_state.switch_state.connect(change_state)
	
	change_state(initial_state)
	
	$"../SMDebug".visible = debug_mode
		
func _process(delta: float) -> void:
	active_state.update(delta)
	
	if debug_mode:
		$"../SMDebug".text = active_state.name
	
func _physics_process(delta: float) -> void:
	active_state.physics_update(delta)

func change_state(new_state: State) -> void:
	if new_state == active_state:
		return
		
	if active_state:
		active_state.exit()
	
	active_state = new_state
	
	if active_state:
		active_state.enter()
