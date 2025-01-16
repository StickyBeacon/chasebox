extends Node

var current_sprites :AnimatedSprite2D = null:
	set(value):
		current_sprites = value
		value.visible = true
		starting_scale = current_sprites.scale.x
	
@onready var player = $"../.."
var previous_state = "Idle"
var interruptable_dict = {"Idle":true,"Air":true,"Roll":false,"Run":true,"Wall":true,"Jump":false}
const STRETCH_DIVIDER = 2000
const ROTATE_DIVIDER = 2000
var starting_scale = null


func on_sprite_end():
	if previous_state == "Roll":
		change_to_state("Idle")
		return
	elif previous_state == "Jump":
		change_to_state("Air")
		return


func _process(_delta: float) -> void:
	if sign(player.velocity.x) != 0:
		current_sprites.scale.x = float(sign(player.velocity.x)) 
	
	current_sprites.rotation = player.velocity.x / ROTATE_DIVIDER
	
	current_sprites.scale.y = starting_scale + abs(player.velocity.y) / STRETCH_DIVIDER 
	current_sprites.scale.x = sign(current_sprites.scale.x)*(starting_scale - abs(player.velocity.y) / STRETCH_DIVIDER) 
	
	
	if !interruptable_dict[previous_state] : return
	
	if player.is_on_floor():
		if previous_state == "Air":
			change_to_state("Roll")
			return
		
		if %Movement.is_moving():
			change_to_state("Run")
			return
		else:
			change_to_state("Idle")
			return
	
	if player.is_on_wall():
		change_to_state("Wall")
		return

	change_to_state("Air")
	
	
func change_to_state(state):
	if previous_state == state: return
	current_sprites.play(state)
	previous_state = state
