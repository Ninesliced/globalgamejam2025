extends Menu

func _ready():
	is_backable = false


func _on_quit_pressed():
	Global.reload_game()
	Global.menu_manager.set_menu("MainMenu")


func _on_replay_pressed():
	Global.reload_game()
	Global.menu_manager.exit_menu()
