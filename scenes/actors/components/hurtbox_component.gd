@icon("res://_engine/icons/node_2D/icon_area_damage.png")
@tool
extends Component
class_name HurtboxComponent

signal damaged_other(damaged_area: Area2D)

var child_area: Area2D
var damage_amount: float = 1.0

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

    assert(false, "HurtboxComponent: No Area2D was defined for this node.")


func _on_child_area_area_entered(area: Area2D):
    if Engine.is_editor_hint():
        return
    
    if area.get_parent() is HitboxComponent:
        damaged_other.emit(area)


func _get_configuration_warnings():
    for child in get_children():
        if child is Area2D:
            return []
    return ["You must define an Area2D as a child of this node"]