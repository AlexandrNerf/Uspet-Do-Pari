extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.modulate = Color(1, 1, 1, 0)
	$Button.modulate = Color(1, 1, 1, 0)
	var clr = 0
	while $Sprite2D.modulate != Color(1, 1, 1, 1):
		clr += 0.05
		$Sprite2D.modulate = Color(1, 1, 1, clr)
		await get_tree().create_timer(0.1).timeout
	clr = 0
	while $Button.modulate != Color(1, 1, 1, 0.5):
		clr += 0.05
		$Button.modulate = Color(1, 1, 1, clr)
		await get_tree().create_timer(0.1).timeout
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
