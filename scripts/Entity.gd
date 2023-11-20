extends CharacterBody2D
class_name Entity

var behaviour_component: AbstractBehaviourComponent
var chained_component: AbstractChainedComponent

func _ready():
	for child in get_children():
		if child is Component:
			register_child(child)
			
func register_child(x):
	if x is AbstractBehaviourComponent:
		behaviour_component = x
	elif x is AbstractChainedComponent:
		chained_component = x

func delete_equivalent_component(x):
	if x is AbstractBehaviourComponent:
		behaviour_component.queue_free()
	elif x is AbstractChainedComponent:
		chained_component.queue_free()

func set_component(component):
	delete_equivalent_component(component)
	add_child(component)
	register_child(component)
	
