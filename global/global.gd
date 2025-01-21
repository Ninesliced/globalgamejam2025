extends Node

var menu_manager_file = preload("res://scenes/ui/menu/menu_manager.tscn")
var menu_manager: MenuManager

enum PlayMode {
	EIGHT_WAY = 0,
	MOUSE = 1,
}

func _ready() -> void:
	print("======[ GlobalGameJam2025 ]======")
	print("By Team Ninesliced\n")
	
	process_mode = PROCESS_MODE_ALWAYS
	
	menu_manager = menu_manager_file.instantiate()
	add_child(menu_manager)
