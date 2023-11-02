extends CharacterBody2D


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(transform.x * 2000*delta)
	if collision:
		if "constant_size" not in collision.get_collider():
			var modifier = g.modifier_scene_list[g.spell_index].instantiate()
			collision.get_collider().add_child(modifier)
		queue_free()
