extends Node2D

func _ready():
	await get_parent().ready
	if get_parent() and "interactable" in get_parent():
		get_parent().interactable = false

func _exit_tree():
	if "interactable" in get_parent():
		get_parent().interactable = true
