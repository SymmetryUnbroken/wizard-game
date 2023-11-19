extends Component

func _ready():
	if not get_parent():
		await get_parent().ready
	if get_parent() and "interactable" in get_parent():
		get_parent().interactable = false

func _exit_tree():
	if "interactable" in get_parent():
		get_parent().interactable = true
