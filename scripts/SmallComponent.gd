extends Node2D

func _ready():
	if not get_parent():
		await get_parent().ready
	get_parent().scale *= 0.5
	if get_parent().scale.x < 0.01:
		get_parent().queue_free()

func _exit_tree():
	if get_parent():
		get_parent().scale *= 2
