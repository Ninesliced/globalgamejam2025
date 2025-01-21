extends Component

var direction_vector: Vector2
var orthogonal_vector: Vector2

@export var movement_speed := 300.0
@export_range(-360, 360, 0.01, "radians_as_degrees") var direction_angle: float = -PI/2
@export var sine_amplitude := 100.0
@export var sine_wavelength := 10

var time = 0.0

func _ready():
    super()

    direction_vector = Vector2.RIGHT.rotated(direction_angle)
    orthogonal_vector = direction_vector.rotated(PI/2)

func _process(delta):
    time = fmod(time + delta * (TAU / sine_wavelength), TAU)
    var sine_value = sin(time) * sine_amplitude

    assert(get_parent() is CharacterBody2D, "Parent is not a CharacterBody2D")
    get_parent().velocity = orthogonal_vector * sine_value + direction_vector * movement_speed
    