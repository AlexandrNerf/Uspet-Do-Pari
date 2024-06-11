extends CharacterBody2D

@onready var body = $SobakaSprite
@onready var left_bite = $AttackArea/left_bite
@onready var right_bite = $AttackArea/right_bite

const SPEED = 150.0
var HP = 10

var ATTACK_WAIT = 30
var detect_player = false
var direction = "left"
var attacking = false
var stand = true
var atk = false
var hitting = false
var doge = true
var working = false
var plr
var global_delta

func angles(player):
	var ang = (self.position-player.position).angle()
	if ang >= -1.5 and ang < 1.5:
		direction = "left"
	else:
		direction = "right"

func ai(player):
	plr = player
	working = true

func attack(pl, dir):
	attacking = true
	body.play("attack_" + direction)
	await get_tree().create_timer(0.15).timeout
	$Bite.play()
	var t = 0
	while t < 10:
		position += (pl - self.position).normalized() * 5
		await get_tree().create_timer(0.05).timeout
		t += 1
	await get_tree().create_timer(0.1).timeout
	if dir == "left":
		left_bite.disabled = false
	else:
		right_bite.disabled = false
	await get_tree().create_timer(0.3).timeout
	left_bite.disabled = true
	right_bite.disabled = true
	attacking = false
	

func _physics_process(delta):
	$HP_BAR.set_size(Vector2(int((HP*16)/10), 1))
	if working:
		var player = plr
		angles(player)
		if !hitting:
			if atk and !attacking:
				velocity = Vector2(0,0)
				attack(player.position, direction)
			else:
				if player.position.distance_to(position) < 300 and player.position.distance_to(position) > 25:
					stand = false
					if !attacking and !hitting:
						velocity = (player.position - position).normalized() * 100
						move_and_slide()
						body.play("walk_" + direction)
				else:
					velocity = Vector2(0,0)
					stand = true
					body.play("stand_" + direction)
	


func _on_sobaka_sprite_animation_finished():
	if body.animation.begins_with("att"):
		left_bite.disabled = true
		right_bite.disabled = true
		await get_tree().create_timer(0.5).timeout
		attacking = false
		$AnotherAttack.monitoring = true


func _on_doge_area_entered(area):
	if !hitting:
		if area.is_in_group("fireball"):
			hitting = true
			HP -= 6
		elif area.is_in_group("Portfel"):
			hitting = true
			HP -= 8
		if hitting:
			$SobakaSprite.modulate = Color(1, 0.5, 0.5, 1)
			if HP < 0:
				modulate = Color(1, 1, 1, 0.5)
				await get_tree().create_timer(0.2).timeout
				modulate = Color(1, 1, 1, 0.25)
				await get_tree().create_timer(0.2).timeout
				queue_free()
			await get_tree().create_timer(0.4).timeout
			$SobakaSprite.modulate = Color(1, 1, 1, 1)
			hitting = false


func _on_another_attack_area_entered(area):
	if area.is_in_group("Player"):
		atk = true


func _on_another_attack_area_exited(area):
	if area.is_in_group("Player"):
		atk = false


func _on_attack_area_area_entered(area):
	if area.is_in_group("Player"):
		left_bite.disabled = true
		right_bite.disabled = true
