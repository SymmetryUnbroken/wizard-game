extends Node2D

var gvars = g.vars
var fighting_entity = preload("res://scenes/Fighting Entity.tscn")
var character
signal gameover

#func add_enemy(position, wait_time):
#	var temp = fighting_entity.instance()
#	temp.position = position
#	var timer = Timer.new()
#	timer.name = "Timer"
#	timer.autostart = true
#	temp.add_child(timer)
#	timer.wait_time = wait_time
#	temp.set_script(enemy_script)
#	temp.target = $Character
#	add_child(temp)
#	return temp
	
func _ready():
	character = $Character
	character.init_reality(self)
	$CanvasLayer/Gameover.get_ok_button().text = 'Restart'
	$CanvasLayer/Gameover.get_cancel_button().text = 'Exit'
	#$CanvasLayer/Gameover.get_close_button().visible = false
	$CanvasLayer/Gameover.get_ok_button().connect("pressed", Callable(self, "_on_restart"))
	$CanvasLayer/Gameover.get_cancel_button().connect("pressed", Callable(self, "_on_exit"))
	$Character.connect("gameover", Callable(self, "_on_gameover"))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	for enemy in get_tree().get_nodes_in_group("enemies"):
#		enemy.target = $Character
#	if gvars.enemies:
#		for enemy in gvars.enemies:
#			add_enemy(enemy.position, enemy.wait_time)

func _on_exit():
	get_tree().quit()

func _on_restart():
	g.restart()
	get_tree().change_scene_to_file("res://scenes/Actions menu.tscn")

func _on_gameover():
	$CanvasLayer/Gameover.popup()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("mute"):
		$AudioStreamPlayer.playing = not $AudioStreamPlayer.playing
	if event is InputEventMouseMotion and is_instance_valid(character):
		var x = event.relative.x
		$Character.rotation += x/1000
		if $Character.move_and_collide(Vector2()):
			$Character.rotation -= x/1000

func _process(delta):
	pass
#	if get_tree().get_nodes_in_group("enemies").empty():
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		get_tree().change_scene("res://scenes/Actions menu.tscn")
