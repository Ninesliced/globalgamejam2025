extends Menu

func _ready():
	is_backable = false


func _on_quit_pressed():
	Global.menu_manager.set_menu("MainMenu")


func _on_replay_pressed():
	Global.reload_game()
	Global.menu_manager.exit_menu()


#func _input(event):
#	if event is InputEventKey and event.keycode == KEY_ESCAPE and Global.menu_manager. == GameState.LOSE:
#		accept_event()
