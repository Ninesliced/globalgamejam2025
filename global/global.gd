extends Node

var menu_manager_file = preload("res://scenes/ui/menu/menu_manager.tscn")
var menu_manager: MenuManager

func _ready() -> void:
	print("======[ GlobalGameJam2025 ]======")
	process_mode = PROCESS_MODE_ALWAYS
	
	menu_manager = menu_manager_file.instantiate()
	add_child(menu_manager)
