extends AbstractSizeComponent
class_name BigSizeComponent

func _ready():
	super._ready()
	parent.scale = Vector2(2, 2)
	parent.pickable = false
