extends Menu

func _on_quit_pressed():
	Global.menu_manager.set_menu("MainMenu")


func _on_replay_pressed():
	Global.reload_game()
	Global.menu_manager.exit_menu()