extends AbstractChainedComponent

func _ready():
	super._ready()
	if "interactable" in parent:
		parent.interactable = true
