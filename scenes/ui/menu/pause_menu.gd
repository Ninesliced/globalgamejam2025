extends Menu

func _on_button_pressed():
	Global.menu_manager.exit_menu()

func _on_quit_pressed():
	Global.menu_manager.set_menu("MainMenu")
