extends AutodeleteNode

class_name BubblePop

@onready var bubble_cloud : CPUParticles2D = $BubbleCloudParticle
@onready var pop_star : CPUParticles2D = $PopStar

func play():
	$BubbleCloudParticle.emitting = true
	$PopStar.emitting = true
