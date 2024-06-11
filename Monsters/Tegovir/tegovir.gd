extends CharacterBody2D

var HP = 300
var MAX_HP = 300

func jump_attack(playerpos):
	attack = true
	var dirs = "down"
	if playerpos.y < position.y:
		dirs = "up"
	$Body.play("jump_" + dirs)
	await get_tree().create_timer(0.2).timeout
	var start_x = position.x
	var start_y = position.y
	
	var end_x = playerpos.x
	var end_y = playerpos.y
	var delta_x = end_x - start_x
	var delta_y = end_y - start_y
	var x_mid = end_x - delta_x * 0.25
	var y_mid = end_y - delta_y * 0.25
	if end_y == start_y:
		end_y -= 3
	if end_x == start_x:
		end_x -= 3
	var k_main = (end_y - start_y) / (end_x - start_x)
	var k_normal = -1 / k_main
	var b_normal = y_mid - k_normal * x_mid
	var dist = abs(end_x - start_x) / 2
	var x_above_mid
	if (start_y >= end_y):
		x_above_mid = (-1 * dist / sqrt(1 + k_normal*k_normal)) + x_mid
	else:
		x_above_mid = (dist / sqrt(1 + k_normal*k_normal)) + x_mid
	
	var y_above_mid = k_normal * x_above_mid + b_normal
	var points_coeff = 10
	var x_step
	var y_step
	var am_points = floor(sqrt(pow(end_x - start_x, 2) + pow(end_y - start_y, 2)) / points_coeff)
	var step_point = 1 / (am_points - 1);
	var t = 0.0
	$Body.play("flying_" + dirs)
	while t <= 1.0:
		position.x = pow(1 - t, 2) * start_x + 2 * (1 - t) * t * x_above_mid + pow(t, 2) * end_x;
		position.y = pow(1 - t, 2) * start_y + 2 * (1 - t) * t * y_above_mid + pow(t, 2) * end_y;
		t += step_point
		await get_tree().create_timer(0.05*(t+1)).timeout
	$Body.play("fall_" + dirs)
	$Attacks/Jumping.disabled = false
	await get_tree().create_timer(0.5).timeout
	$Attacks/Jumping.disabled = true
	attack = false

var crystall = preload("res://Monsters/Tegovir/crystall.tscn")

func crystalls(player):
	var c = crystall.instantiate()
	get_parent().add_child(c)
	c.position = position
	c.transform = $Marker2D.global_transform
	c.run = true
	await get_tree().create_timer(1.4).timeout
	attack = false

var global_delta = 0
var wait_for_attack = 100
var direction = "down"
var plr
var active = false
var attack = false

func angles(player):
	var rot = (player.position-position).angle()
	if rot >= -0.7853 and rot < 0.7853:
		direction = "right"
		$Marker2D.rotation_degrees = 0
	elif rot >= 0.7853 and rot < 2.356: 
		direction = "down"
		$Marker2D.rotation_degrees = 90
	elif rot >= 2.356 or rot < -2.356:
		direction = "left"
		$Marker2D.rotation_degrees = 180
	elif rot >= -2.356 and rot < -0.7853:
		direction = "up"
		$Marker2D.rotation_degrees = 270


func _ready():
	$Body.play("standing")

func _physics_process(delta):
	if active and HP > 0:
		angles(plr)
	
		if wait_for_attack < 0:
			var dist = plr.position.distance_to(position)
			if dist > 150:
				wait_for_attack = 100
				attack = true
				await get_tree().create_timer(0.3).timeout
				jump_attack(plr.position)
			elif dist < 150:
				wait_for_attack = 100
				attack = true
				crystalls(plr)
		elif !attack:
			if plr.position.distance_to(position) > 45:
				position += (plr.position - self.position).normalized() * 1.5
				$Body.play("moving_" + direction)
			else:
				$Body.play("standing")
			wait_for_attack -= delta * 50
	elif HP < 0:
		$Body.play("standing")


func _on_body_area_area_entered(area):
	if area.is_in_group("Portfel"):
		HP -= 10
		modulate = Color(1, 0.5, 0.5, 1)
		await get_tree().create_timer(0.6).timeout
		modulate = Color(1, 1, 1, 1)
	if area.is_in_group("fireball"):
		HP -= 8
		modulate = Color(1, 0.5, 0.5, 1)
		await get_tree().create_timer(0.6).timeout
		modulate = Color(1, 1, 1, 1)
