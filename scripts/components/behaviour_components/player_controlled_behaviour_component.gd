extends AbstractBehaviourComponent

var CHARACTER_SPEED = 800
var angle_velocity
var _velocity
var last_collision
var lock_on = false
var target

func _ready():
	super._ready()

func _set_velocity(delta):
	var velocity_unrotated = Vector2(Input.get_axis("move_left", "move_right"), 
									 Input.get_axis("move_forward", "move_back"))
	angle_velocity = 0
	var velocity_slide_unrotated = 0.5 * Input.get_axis("slide_left", "slide_right")
	var velocity_slide = Vector2(velocity_slide_unrotated, 0).rotated(parent.rotation + PI/2)
	_velocity = velocity_unrotated
	if _velocity.length() > 0.01:
		var diff = fmod(_velocity.angle() - parent.rotation +  6*PI/2, 2*PI) - PI
		angle_velocity = 10*diff
	_velocity += velocity_slide
	if Input.is_key_pressed(KEY_SHIFT): 
		angle_velocity *= 5
	_velocity *= CHARACTER_SPEED


func _set_position(delta):
	#$CameraHolder.rotation += delta * ang_vel_camera
	parent.rotation += delta * angle_velocity
	if parent.move_and_collide(Vector2()):
		parent.rotation -= delta * angle_velocity

	last_collision = parent.move_and_collide(delta * _velocity)
		#$CameraHolder.rotation += ang_vel_camera * delta
		#$CameraHolder.rotation -= delta * angle_velocity
	if lock_on:
		if is_instance_valid(target):
			rotation = (target.position - position).angle()

func destroy_carried():
	if parent.carried:
		parent.carried.queue_free()
		parent.carried = null
		parent.get_node("CollisionPolygon2D").queue_free()
		parent.get_node("Sprite2D").queue_free()
#
func process_special_collisions():
	if last_collision:
		if parent.carried and "use_as_tool" in parent.carried:
			parent.carried.use_as_tool(parent, last_collision.get_collider())
#		if parent.carried is Key:
#			var lock = last_collision.get_collider().get_node_or_null("ChainedComponent")
#			if lock:
#				lock.queue_free()
#				destroy_carried()
#		last_collision = null
		
func _physics_process(delta):
	if parent:
		_set_velocity(delta)
		_set_position(delta)
		process_special_collisions()
