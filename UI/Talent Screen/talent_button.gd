extends Button

var has_been_pressed: bool = false:
	set(value): 
		has_been_pressed = value
		disabled = has_been_pressed
