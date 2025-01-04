extends RigidBody2D

var owner_id:int = 0
const SHOOT_POWER :float= 1000.0
const WEIGHT :float= 2.0
const RANDOM_ROTATION_MULT = PI/12
const PUNCH:float = 25.0


# Activeert de kogel, gevend de playerid, rotatie en player_snelheid
func activate(user_id, new_rot, shooter_velocity):
	self.owner_id = user_id
	rotation = new_rot + randf_range(-RANDOM_ROTATION_MULT,RANDOM_ROTATION_MULT)
	linear_velocity = shooter_velocity + Vector2.RIGHT.rotated(rotation)*SHOOT_POWER


func _physics_process(delta: float) -> void:
	linear_velocity += get_gravity()*WEIGHT*delta


func remove():
	queue_free()


func _on_player_collision_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		printerr("%s: %s is not a Player!" % [name,body])
	
	if body.player_id != owner_id:
		body.hit_player(self)


func _on_ground_collision_area_body_entered(body: Node2D) -> void:
	remove()
