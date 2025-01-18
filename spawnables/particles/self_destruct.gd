extends GPUParticles2D

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	emitting = true


func _on_timer_timeout() -> void:
	queue_free()
