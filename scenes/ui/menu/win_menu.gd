extends Menu

func _ready():
	is_backable = false
	menu_set.connect(set_best_time)

func _on_quit_pressed():
	Global.reload_game()
	Global.menu_manager.set_menu("MainMenu")


func _on_replay_pressed():
	Global.reload_game()
	Global.menu_manager.exit_menu()

func set_best_time():
	if %BestTime:
		%BestTime.text = Global.get_best_time()