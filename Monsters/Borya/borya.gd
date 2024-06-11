extends CharacterBody2D

@onready var body = $Bdy

const SPEED = 200.0
var HP = 11
var detect_player = false
var direction = "left"
var attacking = false
var stand = true
var can_atk = false
var working = false
func ai(player):
	var ang = (self.position-player.position).angle()
	
	if ang >= -1.5 and ang < 1.5:
		direction = "left"
	else:
		direction = "right"
		
	if can_atk and !attacking:
		attack(player.position)
		
	if player.position.distance_to(position) < 150:
		if player.position.distance_to(position) < 35:
			stand = true
			velocity = Vector2(0, 0)
		else:
			stand = false
			if !attacking:
				velocity = (player.position - self.position).normalized() * SPEED
	else:
		stand = true
	
func attack(pos):
	velocity = Vector2(0, 0)
	attacking = true
	body.play("attack_" + direction)
	await get_tree().create_timer(0.15).timeout
	$AttackBox/Left.disabled = false
	$AttackBox/Right.disabled = false
	
func _physics_process(delta):
	$HP_BAR.set_size(Vector2(int((HP*16)/30), 1))
	if !attacking:
		if stand:
			body.play("standing")
		else:
			body.play("moving_" + direction)
	if HP < 0:
		queue_free()
	move_and_slide()



func _on_hit_box_area_entered(area):
	if area.is_in_group("fireball"):
		HP -= 5
		modulate = Color(1, 0.5, 0.5, 1)
		await get_tree().create_timer(1).timeout
		modulate = Color(1, 1, 1, 1)
	elif area.is_in_group("Portfel"):
		HP -= 10
		modulate = Color(1, 0.5, 0.5, 1)
		await get_tree().create_timer(1).timeout
		modulate = Color(1, 1, 1, 1)


func _on_bdy_animation_finished():
	if body.animation.begins_with("att"):
		attacking = false
		$AttackBox/Left.disabled = true
		$AttackBox/Right.disabled = true


func _on_find_area_entered(area):
	if area.is_in_group("Player"):
		can_atk = true


func _on_find_area_exited(area):
	if area.is_in_group("Player"):
		can_atk = false

