extends AbstractSizeComponent
class_name MediumSizeComponent

func _ready():
	super._ready()
	parent.scale = Vector2(1, 1)
	parent.pickable = true
