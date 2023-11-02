extends CharacterBody2D

var ang_vel = 0
signal weapon_collision

func _ready():
	add_to_group('weapons')


func _set_position(delta):
	position = Vector2(50, 0)
	var collision = move_and_collide(Vector2(0, 0))
	if collision:
		emit_signal("weapon_collision", collision)
		

func _physics_process(delta):
	_set_position(delta)
