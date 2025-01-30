extends Menu

func _ready() -> void:
	is_backable = false

func _on_play_pressed():
	Global.menu_manager.exit_menu()


func _on_quit_button_pressed():
	Global.quit()


func _on_terminator_pressed():
	Global.challenge_mode = Global.ChallengeMode.TERMINATOR
	Global.menu_manager.exit_menu()
	pass # Replace with function body.

func _on_pacific_pressed():
	Global.challenge_mode = Global.ChallengeMode.PACIFIC
	Global.menu_manager.exit_menu()

	pass # Replace with function body.
