extends Node

var _trauma:float = 0
const TIME_MULTIPLIER:float= 1.5

const MAX_ROLL:float = 1
const MAX_PITCH:float = 1
const MAX_YAW:float = 1


func _physics_process(delta: float) -> void:
	if _trauma > 0:
		_trauma -= delta*TIME_MULTIPLIER
		apply_shake()
	

func add_trauma(amount):
	_trauma += amount
	_trauma = clamp(_trauma,0,1)


func get_trauma():
	return pow(_trauma,2)


func apply_shake():
	var noise_vector = Vector3.ZERO #TODO dit moet een andere vector zijn een noise vector
	%Shaker.rotation.z = MAX_ROLL * get_trauma() * noise_vector.x
	%Shaker.rotation.x = MAX_PITCH * get_trauma() * noise_vector.y
	%Shaker.rotation.y = MAX_YAW * get_trauma() * noise_vector.z
