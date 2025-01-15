extends Node

@onready var current_sprites = $"../../QueenSprites"
@onready var player = $"../.."
var previous_state = "Idle"


func on_sprite_end():
	pass


func _process(delta: float) -> void:
	current_sprites.scale.x = float(sign(player.velocity.x)) 
	
	if player.is_on_floor():
		if %Movement.is_moving():
			current_sprites.play("Run")
			return
		else:
			current_sprites.play("Idle")
			return
	
	if player.is_on_wall():
		current_sprites.play("Wall")
		return
	
