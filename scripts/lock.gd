extends AbstractChainedComponent
class_name ChainedComponent
func _ready():
	super._ready()
	if "interactable" in parent:
		parent.interactable = false
