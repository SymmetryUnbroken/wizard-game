extends CharacterBody2D

var gvars = g.vars

var reality
var _velocity = Vector2()
var ang_vel_camera = 0
var angle_velocity = 0
var weapon
var lock_on_threshold = 800
var CHARACTER_VELOCITY = 800
var CAMERA_DAMPING_LOW = 0.2
var CAMERA_DAMPING_HIGH = 1.4
var camera_turn_damping = CAMERA_DAMPING_LOW
var lock_on = false
var target = null
var Fireball = preload("res://scenes/sigil.tscn")
var last_collision = null
signal gameover
var carried
var pos_on_carry_start

func init_reality(reality_input):
	reality = reality_input
	
func _ready():
	add_to_group('creatures')
	$CameraHolder/Camera2D.position = Vector2(0, -320)
	if gvars.spear:
		weapon = gvars.spear.duplicate()
		weapon.name = "Halberd"
		weapon.set_script(load("res://scripts/Halberd.gd"))
		$Hand.add_child(weapon)
		weapon.connect("weapon_collision", Callable($Hand, "on_weapon_collision"))
		add_collision_exception_with(weapon)
		weapon.add_collision_exception_with(self)
	else:
		weapon = null



func _set_velocity(delta):
	var velocity_unrotated = Vector2(0, Input.get_axis("move_forward", "move_back"))
	angle_velocity = Input.get_axis("move_left", "move_right")
	var velocity_slide_unrotated = 0.5 * Input.get_axis("slide_left", "slide_right")
	ang_vel_camera = Input.get_axis("camera_left", "camera_right")
	var velocity_slide = Vector2(velocity_slide_unrotated, 0).rotated(rotation + PI/2)
	_velocity = velocity_unrotated.rotated(rotation + $CameraHolder.rotation)
	if _velocity.length() > 0.01:
		$Direction.rotation = _velocity.angle() - rotation + PI/2
		$CameraHolder.rotation = fmod($CameraHolder.rotation, 2*PI)
		var diff = fmod(velocity_unrotated.angle() + $CameraHolder.rotation + 5*PI, 2*PI) - PI
		#angle_velocity = 10*diff
		ang_vel_camera += velocity_unrotated.x*camera_turn_damping
	else:
		pass#angle_velocity = 0
	_velocity += velocity_slide
	#if Input.is_key_pressed(KEY_SHIFT):
	#	_velocity *= 0.1
	#	angle_velocity *= 0.1
	if Input.is_key_pressed(KEY_SHIFT): 
		#_velocity *= 10
		angle_velocity *= 5
	_velocity *= CHARACTER_VELOCITY
	
var swing_held = false

func get_hit():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("gameover")
	queue_free()
	
func cast():
	var fireball = Fireball.instantiate()
	reality.add_child(fireball)
	fireball.transform = global_transform
	fireball.position += transform.x * 150
	fireball.move_and_collide(Vector2())

func detect_interactable():
	var bodies = $HoldSpace.get_overlapping_bodies()
	for body in bodies:
		if "pickable" in body and body.pickable or \
			"interactable" in body and body.interactable:
			return body

func interact():
	if carried:
		var polygon = get_node("CollisionPolygon2D")
		var sprite = get_node("Sprite2D")
		polygon.reparent(carried)
		sprite.reparent(carried)
		carried.position += polygon.position
		sprite.position -= polygon.position
		polygon.position = Vector2()
		
		carried = null
	var interactable = detect_interactable()
	if interactable:
		if "pickable" in interactable and interactable.pickable:
			interactable.get_node("CollisionPolygon2D").reparent(self)
			interactable.get_node("Sprite2D").reparent(self)
			carried = interactable
			pos_on_carry_start = position
		elif interactable.interactable:
			interactable.interact(self)
	
		
func _input(event):
	if event.is_action_pressed("swing"):
		cast()
	if event.is_action_pressed("next_spell"):
		g.next_spell()
		#if not swing_held:
		#	$Hand.swing()
		#swing_held = true
	elif event.is_action_released("swing"):
		swing_held = false
	if event.is_action_pressed("ui_select"):
		interact()
	if event.is_action_released('lock_on'):
		if lock_on:
			lock_on = false
			target = null
		else:
			var enem = get_tree().get_nodes_in_group("enemies")
			var angle_dif_t
			for enemy in enem:
				if (position - enemy.position).length() < lock_on_threshold:
					var angle_dif = fmod((enemy.position - position).angle() - rotation + 2*PI, 2*PI)
					if angle_dif < PI/4 or angle_dif > 7*PI/4:
						if not is_instance_valid(target) or (angle_dif_t < PI/4 and angle_dif < angle_dif_t) or (angle_dif_t > 7*PI/4 and angle_dif > angle_dif_t):
							target = enemy
							angle_dif_t = angle_dif
			if is_instance_valid(target):
				lock_on = true

func _set_position(delta):
	#$CameraHolder.rotation += delta * ang_vel_camera
	rotation += delta * angle_velocity
	if move_and_collide(Vector2()):
		rotation -= delta * angle_velocity
	if is_instance_valid(weapon) and weapon.move_and_collide(Vector2()):
		rotation -= delta * angle_velocity
	else:
		last_collision = move_and_collide(delta * _velocity)
		if is_instance_valid(weapon):
			weapon.move_and_collide(Vector2())
		#$CameraHolder.rotation += ang_vel_camera * delta
		#$CameraHolder.rotation -= delta * angle_velocity
	if lock_on:
		if is_instance_valid(target):
			rotation = (target.position - position).angle()
			$CameraHolder.rotation = PI/2
		else:
			lock_on = false
	$CameraHolder.rotation = PI/2

func destroy_carried():
	if carried:
		carried.queue_free()
		carried = null
		$CollisionPolygon2D.queue_free()
		$Sprite2D.queue_free()

func process_special_collisions():
	if last_collision:
		if carried is Key:
			var lock = last_collision.get_collider().get_node_or_null("ChainedComponent")
			if lock:
				lock.queue_free()
				destroy_carried()
		last_collision = null

func _physics_process(delta):
	_set_velocity(delta)
	_set_position(delta)
	process_special_collisions()