extends Node

@onready var timer :Timer = %ActualTimer
@onready var label :Label = %TimeLabel


func _physics_process(_delta: float) -> void:
	if !timer.is_stopped():
		label.text = "%.2f" % (timer.wait_time - timer.time_left)


func get_current_time():
	return (timer.wait_time - timer.time_left)
	

func reset_timer():
	label.text = "0"
	timer.stop()


func start_timer():
	timer.start()
