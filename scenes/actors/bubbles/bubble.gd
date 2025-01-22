@icon("res://_engine/icons/node_2D/icon_bubble.png")
extends CharacterBody2D
class_name Bubble

@export var bubble_value := 20.0 

var bubble_cloud_scene: PackedScene = preload("res://scenes/actors/particles/bubble_cloud_particle.tscn")

func _on_hitbox_body_entered(body:Node2D):
	if body.is_in_group("has_OxygenComponent"):
		for child in body.get_children():
			if child is OxygenComponent: 
				child.add_oxygen(bubble_value)
		
		_remove()

func _remove():
	var bubble_cloud: CPUParticles2D = bubble_cloud_scene.instantiate()
	get_parent().add_child(bubble_cloud)
	bubble_cloud.global_position = global_position
	bubble_cloud.emitting = true
	queue_free()

func _process(delta):
	move_and_slide()
