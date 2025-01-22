@icon("res://_engine/icons/node_2D/icon_fish.png")
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bubble_pop_scene: PackedScene = preload("res://scenes/actors/particles/bubble_pop_particle.tscn")

func _physics_process(delta):
	move_and_slide()


func _process(delta):
	$Label.text = str($CaptureOxygenComponent.oxygen_stored)

func _on_hitbox_component_recieved_damage(damager_area: Area2D, damage_amount: float):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	if not body.is_in_group("has_DashComponent"):
		return
	var is_dashed_on = false
	for child in body.get_children():
		if child is DashComponent:
			is_dashed_on = child.is_dashing
	if not is_dashed_on:
		return
	for child in body.get_children():
		if child is OxygenComponent:
			var oxygen_captured = $CaptureOxygenComponent.oxygen_stored
			if not oxygen_captured:
				return
			child.add_oxygen(oxygen_captured)
			var bubble_cloud = bubble_pop_scene.instantiate()
			get_parent().add_child(bubble_cloud)
			bubble_cloud.global_position = global_position
			bubble_cloud.play()
			queue_free()
