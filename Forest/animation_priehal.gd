extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().get_scene
	$Marshrutka.textr.play("edet")
	while $Marshrutka.position > Vector2(0, 0):
		$Marshrutka.position -= Vector2(6.4, 3.2)
		await get_tree().create_timer(0.05).timeout
	$Marshrutka.textr.play("stoit")
	await get_tree().create_timer(0.5).timeout
	$AndrewKulek.visible = true
	await get_tree().create_timer(2).timeout
	Singletone.animated = false
	get_tree().change_scene_to_file("res://node_2d.tscn")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
