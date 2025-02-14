@icon("res://_engine/icons/node_2D/icon_bubble.png")
extends CharacterBody2D
class_name Bubble

var size := 1.0

@export var max_bubble_content := 20.0
@export var bubble_value := 20.0 :
	set(value):
		value = clamp(value, 0, max_bubble_content)
		bubble_value = value
		size = 1.3 ** value / 10
		scale = Vector2(size, size)

var bubble_pop_scene: PackedScene = preload("res://scenes/actors/particles/bubble_pop_particle.tscn")

func _on_hitbox_body_entered(body:Node2D):
	var oxygen_component = null
	if body.is_in_group("has_OxygenComponent"):
		for child in body.get_children():
			if child is OxygenComponent: 
				oxygen_component = child
				child.add_oxygen(bubble_value)
		handle_refund_dash(body, oxygen_component)
		_remove()

func handle_refund_dash(body, oxygen_component):
	if body.is_in_group("has_DashComponent"):
		for child in body.get_children():
			if child is DashComponent:
				if !child.is_dashing:
					return
				print("Refund dash")
				oxygen_component.add_oxygen(child.dash_consumption)

func _remove():
	var bubble_cloud : BubblePop = bubble_pop_scene.instantiate()
	get_parent().add_child(bubble_cloud)
	bubble_cloud.global_position = global_position
	bubble_cloud.bubble_cloud.scale_amount_max = size
	bubble_cloud.bubble_cloud.scale_amount_min = size
	bubble_cloud.pop_star.scale_amount_max = size
	bubble_cloud.pop_star.scale_amount_min = size
	bubble_cloud.play()

	queue_free()

func _process(delta):
	move_and_slide()
