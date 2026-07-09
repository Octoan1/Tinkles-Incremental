extends Node

var goo: float = 0.0
var ui_node = CanvasLayer

func modify_goo(amount):
	goo += amount
	ui_node.update_ui()
