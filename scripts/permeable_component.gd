extends Node2D

func _ready():
	if not get_parent():
		await get_parent().ready
	if get_parent() and "interactable" in get_parent() or "pickable" in get_parent():
		get_parent().get_node("CollisionPolygon2D").disabled = true

func _exit_tree():
	if "interactable" in get_parent():
		var polygon = get_parent().get_node_or_null("CollisionPolygon2D")
		if polygon:
			polygon.disabled = false
