@icon("res://_engine/icons/node_2D/icon_fish.png")

extends CharacterBody2D
class_name Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bubble_pop_scene: PackedScene = preload("res://scenes/actors/particles/bubble_pop_particle.tscn")
var can_move = true
var spinning = false
var spin_time = 0.5
var damage_player = false

@onready var icon : Sprite2D = $Icon

signal died

func _physics_process(delta):
	if spinning:
		spin_time -= delta
		rotation += 360 * delta
		if spin_time <= 0:
			spinning = false
			queue_free()
		return
	if can_move:
		move_and_slide()

func _process(delta):
	if $Label:
		$Label.text = str($CaptureOxygenComponent.oxygen_stored)
	if damage_player and not $CaptureOxygenComponent.is_captured:
		var player = get_tree().current_scene.get_node("Player")
		player.Oxygen_component.add_oxygen(-10 * delta)

func _on_hitbox_component_recieved_damage(damager_area: Area2D, damage_amount: float):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	get_dashed_on((body))

func get_dashed_on(body: Node2D) -> void:
	if not body.is_in_group("has_DashComponent"):
		return

	var is_dashed_on = false

	for child in body.get_children():
		if child is DashComponent:
			is_dashed_on = child.is_dashing

	if not is_dashed_on:
		damage_player = true
		return

	for child in body.get_children():
		if child is OxygenComponent:
			var is_captured = $CaptureOxygenComponent.is_captured
			if not is_captured:
				return
			var oxygen_captured = $CaptureOxygenComponent.oxygen_stored * 4
			if not oxygen_captured:
				return

			child.add_oxygen(oxygen_captured)
			var bubble_cloud = bubble_pop_scene.instantiate()
			get_parent().add_child(bubble_cloud)
			bubble_cloud.global_position = global_position
			bubble_cloud.play()
			spinning = true

			$DeathSound.play()
			
			died.emit()

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
