extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AndreiDance.play('default')
	$AlexDance.play('default')
	$Music.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label2.position -= Vector2(0,delta*4)
	pass


func _on_button_pressed():
	$Music.play()
	get_tree().change_scene_to_file("res://node_2d.tscn")
	#queue_free()
