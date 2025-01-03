extends Node

@onready var player :CharacterBody2D = $"../.."

const SPEED = 500.0
const AIR_ACCEL = 10.0
const GROUND_GRIP = 3000.0
const JUMP_VELOCITY = -600.0
# Als je down inhoud val je sneller
const DOWN_GRAV_MULTIPLIER = 4.0
# Als je in de lucht bent ga je sneller. Zie implementation
const JUMP_EXP_MODIFIER = 0.3
var is_jump_buffered = false
# Als je jump loslaat, ga je minder hard stijgen
const JUMP_RELEASE_MODIFIER = 4.0
var is_jump_held_in = false
# Rounds coyote-walljump mechanic
var free_jump = false

var input_dict = {"jump" = null,"shoot"= null,"left"= null,"right"= null,"up"= null,"down"= null}


func _ready() -> void:
	var player_number = 1 if player.is_player_1 else 2
	
	for key in input_dict.keys():
		input_dict[key] = key + str(player_number)


func _input(event: InputEvent) -> void:
	if event.is_action_released(input_dict["jump"]) and is_jump_held_in:
		is_jump_held_in = false


func _physics_process(delta: float) -> void:
	if (player.is_on_floor() or player.is_on_wall()) and !free_jump:
		free_jump = true
	
	# Handle gravity
	if not player.is_on_floor():
		_add_gravity(delta)
		
	# Add jump buffer
	elif is_jump_buffered:
		_activate_jump()
	
	# Handle jump press
	if Input.is_action_just_pressed(input_dict["jump"]):
		is_jump_held_in = true
		if free_jump: # free jump!
			_activate_jump()
		else: #Start buffer
			is_jump_buffered = true
			%JumpBufferTimer.stop()
			%JumpBufferTimer.start()
			

	
	# Get movement input
	var direction := Input.get_axis(input_dict["left"],input_dict["right"])
	
	# Apply movement 
	if player.is_on_floor():
		if direction:
			player.velocity.x = move_toward(player.velocity.x,(direction * SPEED), delta*GROUND_GRIP)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, GROUND_GRIP*delta)
	else:
		if direction:
			player.velocity.x = lerp(player.velocity.x, JUMP_EXP_MODIFIER * player.velocity.x + (direction * SPEED), delta*AIR_ACCEL)
	
	# The usual
	player.move_and_slide()


func _add_gravity(delta):
	var _down_modifier = 1 if !Input.is_action_pressed(input_dict["down"]) else DOWN_GRAV_MULTIPLIER
	var _release_modifier = 1 if is_jump_held_in or player.velocity.y>0 else JUMP_RELEASE_MODIFIER 
	
	player.velocity += player.get_gravity() * delta * _down_modifier * _release_modifier


func _on_jump_buffer_timer_timeout() -> void:
	is_jump_buffered = false


func _activate_jump():
	player.velocity.y = JUMP_VELOCITY
	is_jump_buffered = false
	%JumpBufferTimer.stop()
	free_jump = false
