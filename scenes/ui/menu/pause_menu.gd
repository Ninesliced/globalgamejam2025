extends Menu

func _on_quit_pressed():
	Global.reload_game()
	Global.menu_manager.set_menu("MainMenu")


func _on_resume_pressed():
	Global.menu_manager.exit_menu()
