extends Entity

var interactable = true
var is_open = false
var initial_rotation = rotation
var eps = 0.01
var angle_velocity = 0
	
func close():
	pass
	
func interact(_other):

	if is_open:
		if rotation - initial_rotation <= PI/2 + eps:
			angle_velocity = 5
	else: 
		if rotation - initial_rotation >= -eps:
			angle_velocity = -5
	is_open = not is_open

func _physics_process(delta):
	if rotation - initial_rotation > PI/2 + eps:
		rotation = initial_rotation + PI/2
		angle_velocity = 0
	if rotation - initial_rotation < -eps:
		rotation = initial_rotation
		angle_velocity = 0
	rotation += delta * angle_velocity

