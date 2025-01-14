extends Node

@onready var player :Player = $"../.."
var _input_dict = {"jump" = null,"shoot"= null,"left"= null,"right"= null,"up"= null,"down"= null}

var _bullet_type = preload("res://spawnables/basic_bullet.tscn")
var _aim_rot:float = 0
const AIM_LERP_SPEED = 15


func _ready() -> void:
	for key in _input_dict.keys():
		_input_dict[key] = key + str(player.controller_id)


func _input(event: InputEvent) -> void:
	if !player.enabled: return
	if event.is_action_pressed(_input_dict["shoot"]):
		shoot()


func _process(delta: float) -> void:
	var _input_vector = Input.get_vector(_input_dict["left"],_input_dict["right"],_input_dict["up"],_input_dict["down"])
	if _input_vector != Vector2.ZERO:
		var target_rot = atan2(_input_vector.normalized().y,_input_vector.normalized().x)
		_aim_rot = lerp_angle(_aim_rot,target_rot,delta*AIM_LERP_SPEED)
		%AimCursor.rotation = _aim_rot
		


func shoot():
	var _new_bullet = _bullet_type.instantiate()
	get_tree().root.add_child(_new_bullet)
	_new_bullet.position = player.global_position
	_new_bullet.activate(player.player_id, _aim_rot, player.velocity)
	# -> rotate bullet according to _aim_rot
	# -> Add trauma based on bullet strength
	pass


func change_bullet_type(bullet):
	print("changed bullet type")
	_bullet_type = bullet
