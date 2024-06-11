extends CharacterBody2D

var wait_attack = false
var cone = preload("res://Monsters/Belka/cone.tscn")
var is_cone
var defence = false
var HP = 20
var dead = false

func attack(obj, fb):
	if !dead:
		var c = cone.instantiate()
		c.target = obj
		#get_tree().root.add_child(c)
		if fb:
			c.fb = true
		get_parent().add_child(c)
		c.position = position + Vector2(0, -10)
		c.start()
		is_cone = c
	
func ai(player):
	if player.position.distance_to(position) < 300 and !is_instance_valid(is_cone) and !wait_attack:
		wait_and_attack(player)
	if player.position.x > position.x:
		$Belka.play("new_animation")
	else:
		$Belka.play("default")
	if is_instance_valid(player.now_ball) and !is_instance_valid(is_cone):
		attack(player.now_ball, 1)


func wait_and_attack(player):
	wait_attack = true
	attack(player, 0)
	await get_tree().create_timer(4).timeout
	wait_attack = false

func _physics_process(delta):
	if HP < 0:
		dead = true
		modulate = Color(1, 1, 1, 0.75)
		await get_tree().create_timer(0.2).timeout
		modulate = Color(1, 1, 1, 0.5)
		await get_tree().create_timer(0.2).timeout
		modulate = Color(1, 1, 1, 0.25)
		await get_tree().create_timer(0.2).timeout
		queue_free()
	pass
	


func _on_hb_area_entered(area):
	if area.is_in_group("Portfel"):
		HP -= 300
		modulate = Color(1, 0.5, 0.5, 1)
		$Tree.play("default")
		await get_tree().create_timer(1).timeout
		modulate = Color(1, 1, 1, 1)
	if area.is_in_group("fireball"):
		HP -= 4
		modulate = Color(1, 0.5, 0.5, 1)
		$Tree.play("default")
		await get_tree().create_timer(1).timeout
		modulate = Color(1, 1, 1, 1)
	
