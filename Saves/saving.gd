extends Node

func _process(delta):
	pass

func save_state():
	var file = SaveFile.new()
	if file.open("user://saved_game.dat", File.WRITE) == OK:
		var state = {
			"main_scene": get_tree().get_current_scene().get_filename(),
			"child_scenes": []
		}
		for child in get_tree().get_current_scene().get_children():
			state["child_scenes"].append(child.get_filename())
		file.store_var(state)
		file.close()

func load_state():
	var file = File.new()
	if file.open("user://saved_game.dat", File.READ) == OK:
		var state = file.get_var()
		# Здесь реализуйте загрузку состояния и восстановление сцен
		file.close()
