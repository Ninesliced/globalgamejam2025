extends CPUParticles2D
class_name AutodeleteParticle

@export_range(0, 1000000000, 0.01, "suffix:s") var delete_time = 3.0

func _ready():
    var timer = Timer.new()
    timer.wait_time = delete_time
    timer.start()
    timer.timeout.connect(func():
        queue_free()
    )
