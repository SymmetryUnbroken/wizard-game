extends Node2D

var state = 'idle'
var ang_vel = 0
var x_vel = 0

func swing():
	if state == 'idle':
		state = 'left'
	
func _set_velocity(delta):
	if state == 'left' and rotation <= -0.5:
		state = 'right'
	if state == 'right' and rotation >= 0:
		state = 'idle'
		position.x = 0
	if state == 'left':
		ang_vel = -3
		x_vel = 18
	if state == 'right':
		ang_vel = 1
		x_vel = -6
	if state == 'idle':
		ang_vel = 0
		x_vel = 0

func on_weapon_collision(collision):
	if collision.collider.is_in_group('creatures'):
		if state == 'left':
			collision.collider.get_hit()
	if state == 'left':
		state = 'right'

func _physics_process(delta):
	_set_velocity(delta)
	_set_position(delta)
	
func _set_position(delta):
	rotation += ang_vel * delta
	position += Vector2(x_vel, 0)
