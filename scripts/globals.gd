extends Control

var small_scene = preload("res://scenes/small_component.tscn")
var permeable_scene = preload("res://scenes/permeable_component.tscn")
var modifier_scene_list = [small_scene, permeable_scene]
var spell_name_list = ["Small", "Permeable"]
var spell_index = 0

func next_spell():
	spell_index += 1
	if spell_index >= modifier_scene_list.size():
		spell_index = 0
		
var vars = {
	'gold': 10,
	'land': 0,
	'current_location': "Forge",
	'inv': [],
	'spear': null,
	'equipped_n': null,
	'enemies': null,
	'victory_declared': false
}

var tracked_labels = []

func restart():
	vars = {
	'gold': 10,
	'land': 0,
	'current_location': "Forge",
	'inv': [],
	'spear': null,
	'equipped_n': null,
	'enemies': null,
	'victory_declared': false
}
	tracked_labels = []

func update_labels():
	for item in tracked_labels:
		if is_instance_valid(item.label):
			item.label.text = item.text + str(vars[item.var])
		else:
			tracked_labels.erase(item)

func generate_menu(root, menu_layout, theme):
	var menu = root
	menu.theme = theme
	menu.update_labels = update_labels#FuncRef.new()
	#menu.update_labels.set_function("update_labels")
	#menu.update_labels.set_instance(self)
	var i = 0
	var j = 0
	for column in menu_layout:
		for elem in column:
			var new_item
			if elem.type == "Label":
				new_item = Label.new()
				new_item.text = elem.text
				if "var" in elem.keys():
					new_item.text += str(vars[elem.var])
				tracked_labels.append({
					"label": new_item,
					"text": elem.text,
					"var": elem.var
				})
			elif elem.type == "Button":
				new_item = Button.new()
				if "text" in elem.keys():
					new_item.text = elem.text
				if "func" in elem.keys():
					if "func_params" in elem.keys():
						new_item.connect("pressed", Callable(root, elem.func).bind(elem.func_params))
					else:
						new_item.connect("pressed", Callable(root, elem.func))
			if "name" in elem.keys():
				new_item.name = elem.name
			if "attach" in elem:
				var attach = elem.attach.item.duplicate()
				attach.position = elem.attach.pos
				new_item.add_child(attach)
			new_item.set_position(Vector2(30 + j*700, 30 + 80*i))
			menu.add_child(new_item)
			i += 1
		j += 1
		i = 0
			


