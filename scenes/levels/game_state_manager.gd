extends Node2D
class_name GameStateManager

@export var player : Player = null
var oxygen_component : OxygenComponent = null
enum GameState {
	LOSE = 0,
	WIN = 1,
}
var game_state := GameState.LOSE
# Called when the node enters the scene tree for the first time.
func _ready():
	if player == null:
		printerr("No player in the scene")
		return
	
	if player.is_in_group("has_OxygenComponent"):
		oxygen_component = player.get_node("OxygenComponent")
		if oxygen_component != null:
			print("connect")
			oxygen_component.connect("run_out_of_oxygen", set_lose_state)
			return
		else:
			printerr("No oxygen component in the player, shouldn't print this error, it does mean that comopnents system not working")
			pass
	else:
		printerr("Player is not in the oxygen component group")
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_lose_state():
	print("You lose")
	game_state = GameState.LOSE
	Global.menu_manager.set_menu("GameOverMenu")