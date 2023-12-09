extends AbstractSizeComponent
class_name SmallSizeComponent

func _ready():
	super._ready()
	parent.scale = Vector2(0.5, 0.5)
	parent.pickable = true
