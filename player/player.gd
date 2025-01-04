extends CharacterBody2D
class_name Player

@export var player_id = 0

@export var is_chaser = false:
	set(value):
		is_chaser = value
		%ChaseHitbox.monitoring = value


func hit_player(object):
	print("%s got hit by %s" % [name, object.name]) 
	if !is_chaser:
		kill_player()
	else:
		%Movement.add_force(object.PUNCH*(global_position-object.global_position))
		object.remove()
		# if object in
		# check ofdat de object harmful is aan chasers
		# check de zender ID
		# add force aan speler?
		pass


func _on_chase_hitbox_body_entered(body: Node2D) -> void:
	if !body.is_chaser:
		body.hit_player(self)
		

func kill_player():
	print("%s: dies" % name)
