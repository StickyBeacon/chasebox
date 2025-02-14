extends Node

var noise = FastNoiseLite.new()
var noise_time = 0
const NOISE_TIME_MULTIPLIER = 500


func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi_range(0,100)
	

func _process(delta: float):
	noise_time += delta*NOISE_TIME_MULTIPLIER


func get_vector3():
	return Vector3(noise.get_noise_2d(noise.seed,noise_time),noise.get_noise_2d(noise.seed*2,noise_time),noise.get_noise_2d(noise.seed*3,noise_time))


func get_value():
	return noise.get_noise_2d(noise.seed,noise_time)


var _trauma:float = 0
const SHAKE_TIME_MULTIPLIER:float= 5

const MAX_X:float = 50
const MAX_Y:float = 50
const MAX_ROTATION:float = 1


func _physics_process(delta: float) -> void:
	if _trauma > 0:
		_trauma -= delta*SHAKE_TIME_MULTIPLIER
		apply_shake()
	

func add_trauma(amount):
	_trauma += amount
	_trauma = clamp(_trauma,0,1)


func get_trauma():
	return pow(_trauma,2)


func apply_shake():
	var noise_vector = get_vector3() #TODO dit moet een andere vector zijn een noise vector
	%Camera2D.global_position = Vector2(MAX_X * get_trauma() * noise_vector.x,MAX_Y * get_trauma() * noise_vector.y)
