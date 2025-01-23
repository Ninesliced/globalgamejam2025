extends MovementComponent

@export var movement_rate  := 3.0
@export var movement_vec   := Vector2(0.0, 0.2)
@export var movement_brake := 0.5

@onready var movement_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_timer.set_wait_time(movement_rate)


func _process(delta: float) -> void:
	parent.move_and_slide()
	parent.velocity *= movement_timer.time_left / (movement_rate * movement_brake)


func _on_timer_timeout() -> void:
	parent.velocity += movement_vec * speed
	
