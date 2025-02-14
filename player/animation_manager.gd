extends Node

var current_sprites :AnimatedSprite2D = null:
	set(value):
		current_sprites = value
		value.visible = true
		starting_scale = current_sprites.scale.x
	
@onready var player :Player= $"../.."
var previous_state = "Idle"
var interruptable_dict = {"Idle":true,"Air":true,"Roll":false,"Run":true,"Wall":true,"Jump":false}
const STRETCH_DIVIDER = 2000
const ROTATE_DIVIDER = 2000
var starting_scale = null
var dust_particle = preload("res://spawnables/particles/dust.tscn")

var _was_on_wall :bool = false
var _was_on_ceiling :bool = false
var _was_on_floor:bool = false


func on_sprite_end():
	if previous_state == "Roll":
		change_to_state("Idle")
		return
	elif previous_state == "Jump":
		change_to_state("Air")
		return


func _process(_delta: float) -> void:
	# Player sprite shenanigans
	if sign(player.velocity.x) != 0:
		current_sprites.scale.x = float(sign(player.velocity.x)) 
	
	current_sprites.rotation = player.velocity.x / ROTATE_DIVIDER
	
	current_sprites.scale.y = starting_scale + abs(player.velocity.y) / STRETCH_DIVIDER 
	current_sprites.scale.x = sign(current_sprites.scale.x)*(starting_scale - abs(player.velocity.y) / STRETCH_DIVIDER) 
	
	# Player on wall/ceiling? particle time!
	if player.is_on_wall() and !_was_on_wall:
		spawn_dust()
		%WallHitSound.play()
		_was_on_wall = true
	elif !player.is_on_wall():
		_was_on_wall = false
	
	if player.is_on_ceiling_only() and !_was_on_ceiling:
		spawn_dust(.5)
		%CeilingHitSound.play()
		_was_on_ceiling = true
	elif !player.is_on_ceiling():
		_was_on_ceiling = false
	
	if player.is_on_floor() and !_was_on_floor:
		spawn_dust(.5)
		%LandSound.play()
		_was_on_floor = true
	elif !player.is_on_floor():
		_was_on_floor = false
	
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
	#Reset de wall particle (dit is veel meer satisfying)
	if state == "Jump":
		_was_on_wall = false
		_was_on_ceiling = false


func spawn_dust(lightness:float = 1):
	var particle = dust_particle.instantiate()
	particle.modulate = Color(%JumpIndicator.modulate.r*lightness,%JumpIndicator.modulate.g*lightness,%JumpIndicator.modulate.b*lightness)
	particle.global_position = player.global_position + Vector2(0,0.5)
	get_tree().root.add_child(particle)
