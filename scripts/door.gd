extends AnimatableBody2D

var interactable = true
var open = false

func interact(_other):
	if open:
		rotation += PI/2
	else: 
		rotation -= PI/2
	open = not open
