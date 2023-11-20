extends Entity

class_name Key
var pickable = true
var unlocked_scene = preload("res://scenes/components/chained_components/null_chained_component.tscn")

func use_as_tool(user, used_on):
	if "chained_component" in used_on and used_on.chained_component is ChainedComponent:
		used_on.set_component(unlocked_scene.instantiate())
		user.behaviour_component.destroy_carried()
