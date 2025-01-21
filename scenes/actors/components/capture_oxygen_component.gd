extends Component
class_name CaptureOxygenComponent

@export var detection_area: Area2D 

func _ready():
    super()

    assert(detection_area != null, "CaptureOxygenComponent: No detection area defined")
    detection_area.body_entered.connect(_on_detection_area_body_entered)

func _on_detection_area_body_entered(body: Node2D):
    pass