extends Node2D

var shake_player_amount = 0.0
var _rng = RandomNumberGenerator.new()

func _process(delta):
	$Player.position = (Vector2.RIGHT * _rng.randf_range(0, shake_player_amount)).rotated(_rng.randf_range(0, TAU))

	shake_player_amount -= 20*delta

func play():
	$AnimationPlayer.play("dying")

func screenshake():
	var camera = get_viewport().get_camera_2d()
	if camera is CameraManager:
		camera.shake(20)

func shake_player():
	shake_player_amount = 20

func set_game_over():
	get_tree().current_scene.get_node("GameStateManager").set_lose_state()