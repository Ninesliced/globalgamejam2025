@icon("res://_engine/icons/node_2D/icon_hitbox.png")
@tool
extends Component
class_name HitboxComponent

signal recieved_damage(damager_area: Area2D, damage_amount: float)

var child_area: Area2D

func _ready():
	if Engine.is_editor_hint():
		return
	
	super()
	_set_area()

	child_area.area_entered.connect(_on_child_area_area_entered)


func _set_area():
	for child in get_children():
		if child is Area2D:
			child_area = child
			return

	assert(false, "HitboxComponent: No Area2D was defined for this node.")


func _on_child_area_area_entered(area: Area2D):
	if Engine.is_editor_hint():
		return
	
	if area.get_parent() is HurtboxComponent:
		recieved_damage.emit(area, area.get_parent().damage_amount)


func _get_configuration_warnings():
	for child in get_children():
		if child is Area2D:
			return []
	return ["You must define an Area2D as a child of this node"]
