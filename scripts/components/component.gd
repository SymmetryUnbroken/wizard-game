extends Node2D
class_name Component

var parent

func _ready():
	print("lele")
	if not get_parent():
		await get_parent().ready
	parent = get_parent()
