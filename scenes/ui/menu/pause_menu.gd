extends Menu


func _on_resume_pressed():
	Global.menu_manager.exit_menu()


func _on_quit_button_pressed():
	Global.quit()

func _process(delta):
	var volume_val = %VolumeSlider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume_val))