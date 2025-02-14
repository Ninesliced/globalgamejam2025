@icon("res://_engine/icons/node_2D/icon_fish.png")

extends CharacterBody2D
class_name Enemy

@export var damage_value = 15.0
@export var the_derp = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bubble_pop_scene: PackedScene = preload("res://scenes/actors/particles/bubble_pop_particle.tscn")
var can_move = true
var spinning = false
var spin_time = 0.5
var damage_player = false
var oxygen_added = false
var collision : KinematicCollision2D = null
var is_captured = false
@onready var icon : Sprite2D = $Icon


signal died

func _ready():
	var set_is_captured = func():
		is_captured = true
		print("is_captured")
	if $CaptureOxygenComponent:
		$CaptureOxygenComponent.captured.connect(set_is_captured)
	pass

func _physics_process(delta):
	if spinning:
		spin_time -= delta
		rotation += 360 * delta
		if spin_time <= 0:
			spinning = false
			queue_free()
		return
	if can_move:
		collision = move_and_collide(velocity * delta)

func _process(delta):
	if $Label:
		$Label.text = str($CaptureOxygenComponent.oxygen_stored)
	if damage_player and not $CaptureOxygenComponent.is_captured:
		var player = get_tree().current_scene.get_node("Player")
		if damage_value and player:
			player.damage(damage_value)
		damage_player = false
	if !is_captured and $CaptureOxygenComponent.is_captured:
		is_captured = true

func _on_hitbox_component_recieved_damage(damager_area: Area2D, damage_amount: float):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	damage_player = true
	get_dashed_on((body))

func get_dashed_on(body: Node2D) -> void:
	var dash_consumption = 0
	if not body.is_in_group("has_DashComponent"):
		return

	var is_dashed_on = false

	for child in body.get_children():
		if child is DashComponent:
			is_dashed_on = child.is_dashing
			dash_consumption = child.dash_consumption

	if not is_dashed_on:
		return

	for child in body.get_children():
		if child is OxygenComponent:
			var is_captured = $CaptureOxygenComponent.is_captured
			if not is_captured:
				return
			var oxygen_captured = $CaptureOxygenComponent.oxygen_stored * 3 + dash_consumption + 3
			if not oxygen_captured:
				return

			if not oxygen_added:
				child.add_oxygen(oxygen_captured)
			oxygen_added = true
			var bubble_cloud = bubble_pop_scene.instantiate()
			get_parent().add_child(bubble_cloud)
			bubble_cloud.global_position = global_position
			bubble_cloud.play()
			spinning = true

			$DeathSound.play()
			
			died.emit()
			var is_dead 
			if the_derp:
				Global.win_game()

func _on_body_exit(body: Node2D) -> void:
	if body.name != "Player":
		return
	damage_player = false
	get_dashed_on(body)

func disable_movement():
	can_move = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func get_normal():
	if !collision:
		return null
	return collision.get_normal()
