extends Node

@export var health = 100
@export var max_health = 100
@export var invincible = false
@export var invincible_time = 1.0
var invincible_timer : Timer = Timer.new()

signal on_damage(amount : int)
signal on_death()
signal on_heal(amount : int)

func _ready():
	invincible_timer.wait_time = invincible_time
	invincible_timer.one_shot = true
	invincible_timer.timeout.connect(disable_invincibility)

	pass

func take_damage(damage : int):
	if invincible:
		return

	health -= damage
	emit_signal("on_damage", damage)
	if health <= 0:
		emit_signal("on_death")

func heal(amount : int):
	health = min(health + amount, max_health)

func set_invincibility(time : float = invincible_time):
	invincible = true
	invincible_time = time
	invincible_timer.start()

func disable_invincibility():
	invincible = false
	invincible_timer.stop()