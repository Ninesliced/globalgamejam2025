extends Menu

func _ready() -> void:
	is_backable = false

func _on_play_pressed():
	Global.menu_manager.exit_menu()


func _on_quit_button_pressed():
	Global.quit()