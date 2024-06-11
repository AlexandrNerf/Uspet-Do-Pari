extends Node2D

var my_text = "STUDENT TROLLING MACHINE"

# Called when the node enters the scene tree for the first time.
func _ready():
	$STM.modulate = Color(1, 1, 1, 0)
	await get_tree().create_timer(1).timeout
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		$STM.modulate += Color(0, 0, 0, 0.1)
	$STM.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_stm_animation_finished():
	for c in my_text:
		await get_tree().create_timer(0.1).timeout
		$Label/Label.text += c
	await get_tree().create_timer(0.5).timeout
	for i in range(20):
		await get_tree().create_timer(0.035).timeout
		$Label2.scale -= Vector2(0.05, 0.05)
		$Label2.modulate += Color(0, 0, 0, 0.05)
	await get_tree().create_timer(2).timeout
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		$STM.modulate -= Color(0, 0, 0, 0.1)
		$Label2.modulate -= Color(0, 0, 0, 0.1)
		$Label/Label.modulate -= Color(0, 0, 0, 0.1)
	await get_tree().create_timer(1.5).timeout
	var txt = "Посвящается всем студентам, живущим вдали \nот своего вуза, проходящим невероятно\nдлинный путь каждый день. Это игра о тех, \nкто постоянно опаздывает, но не \nпо собственной воле.\nКрепитесь, мы с вами, мы ЗА ВАС!"
	for c in txt:
		await get_tree().create_timer(0.08).timeout
		$Label.text += c
	await get_tree().create_timer(1.5).timeout
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		$Label.modulate -= Color(0, 0, 0, 0.1)
	await get_tree().create_timer(1).timeout
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		$Label3.modulate += Color(0, 0, 0, 0.1)
		$Alert1.modulate += Color(0, 0, 0, 0.1)
		$Alert2.modulate += Color(0, 0, 0, 0.1)
	await get_tree().create_timer(6).timeout
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		$Label3.modulate -= Color(0, 0, 0, 0.1)
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		$Label4.modulate += Color(0, 0, 0, 0.1)
	await get_tree().create_timer(6).timeout	
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		$Label4.modulate -= Color(0, 0, 0, 0.1)
		$Alert1.modulate -= Color(0, 0, 0, 0.1)
		$Alert2.modulate -= Color(0, 0, 0, 0.1)
	await get_tree().create_timer(1).timeout	
	get_tree().change_scene_to_file("res://main_menu.tscn")




func _on_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
