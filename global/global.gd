extends Node

var menu_manager_file = preload("res://scenes/ui/menu/menu_manager.tscn")
var menu_manager: MenuManager

var hud_file = preload("res://scenes/ui/hud/hud.tscn")
var hud: HUD

enum PlayMode {
	EIGHT_WAY = 0,
	MOUSE = 1,
}

func _ready() -> void:
	print("===========[  GlobalGameJam2025  ]===========")
	print("             By Team Ninesliced\n")
	
	process_mode = PROCESS_MODE_ALWAYS
	
	menu_manager = menu_manager_file.instantiate()
	add_child(menu_manager)

	hud = hud_file.instantiate()
	add_child(hud)


func _process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()


func reload_game():
	get_tree().reload_current_scene()


func get_direction(current_pos, play_mode : PlayMode, mouse_pos, minimum_dash_distance_to_mouse = 50) -> Vector2:
	var vec = Vector2(1, 0)
	var new_vec = Input.get_vector("left_visor", "right_visor", "up_visor", "down_visor")
	if new_vec != Vector2.ZERO:
		return new_vec.normalized()	

	if play_mode == Global.PlayMode.MOUSE:
		var mouse_position = mouse_pos
		var distance = (mouse_position - current_pos).length()
		if distance < minimum_dash_distance_to_mouse:
			return vec
		vec = (mouse_position - current_pos).normalized()
		# print(vec)
		return vec
	
	if play_mode == Global.PlayMode.EIGHT_WAY:
		print("eight way")
		new_vec = Input.get_vector("left", "right", "up", "down")
		if new_vec != Vector2.ZERO:
			vec = new_vec.normalized() 
		return vec

	return vec
