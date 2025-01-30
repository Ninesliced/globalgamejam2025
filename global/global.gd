extends Node

var menu_manager_file := preload("res://scenes/ui/menu/menu_manager.tscn")
var menu_manager: MenuManager

var hud_file := preload("res://scenes/ui/hud/hud.tscn")
var hud: HUD

enum ControllerType {
	MOUSE = 0,
	CONTROLLER = 1,
}
var old_direction := Vector2(0, 0)
var old_mouse_pos := Vector2(0, 0)
var controller_type: ControllerType = ControllerType.MOUSE

var timer = Timer.new()

enum PlayMode {
	EIGHT_WAY = 0,
	MOUSE = 1,
}

enum ChallengeMode {
	DEFAULT = 0,
	PACIFIC = 1,
	TERMINATOR = 2,
}

var challenge_mode: ChallengeMode = ChallengeMode.PACIFIC

func _ready() -> void:
	print("===========[  GlobalGameJam2025  ]===========")
	print("             By Team Ninesliced\n")
	
	process_mode = PROCESS_MODE_ALWAYS

	add_child(timer)
	
	menu_manager = menu_manager_file.instantiate()
	add_child(menu_manager)

	hud = hud_file.instantiate()
	add_child(hud)


func _process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()


func reload_game():
	get_tree().reload_current_scene()

func quit():
	get_tree().quit()

func get_direction(current_pos, play_mode : PlayMode, mouse_pos, minimum_dash_distance_to_mouse = 50) -> Vector2:
	var vec = old_direction
	var new_vec = Input.get_vector("left_visor", "right_visor", "up_visor", "down_visor")
	
	if new_vec != Vector2.ZERO:
		controller_type = ControllerType.CONTROLLER
		vec = new_vec.normalized()

	elif play_mode == Global.PlayMode.MOUSE and old_mouse_pos != mouse_pos:
		controller_type = ControllerType.MOUSE
		var mouse_position = mouse_pos
		var distance = (mouse_position - current_pos).length()
		if distance < minimum_dash_distance_to_mouse:
			return vec
		vec = (mouse_position - current_pos).normalized()
		old_direction = vec.normalized()

	# if play_mode == Global.PlayMode.EIGHT_WAY:
	# 	print("eight way")
	# 	new_vec = Input.get_vector("left", "right", "up", "down")
	# 	if new_vec != Vector2.ZERO:
	# 		vec = new_vec.normalized()

	old_mouse_pos = mouse_pos
	old_direction = vec.normalized()
	return vec

func win_game():
	menu_manager.set_menu("WinMenu")
	return 
	# timer.wait_time = 2.0
	# timer.timeout.connect(func():
	# 	timer.stop()
	# 	menu_manager.set_menu("WinMenu")
	# )
	# timer.one_shot = true
	# timer.start()

func kill_tags(tag):
	var tags = get_tree().get_nodes_in_group(tag)
	for t in tags:
		t.queue_free()


func get_best_time():
	var maps = get_tree().get_nodes_in_group("Map")
	if maps.size() == 0:
		return
	var map : Map = maps[0]
	var value = map.game_timer
	var minutes := int(value/60)
	var seconds := fmod(value, 60.0)
	var text = "Best time: %d:%.2f" % [minutes, seconds]
	return text
