extends Sprite2D

@export var ROTATION_SPEED = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(delta*ROTATION_SPEED)
