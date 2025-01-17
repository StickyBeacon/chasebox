extends StaticBody2D


func _ready() -> void:
	%Sprite2D.material.set("shader_parameter/tiling_density",Vector2(scale.x,scale.y))
