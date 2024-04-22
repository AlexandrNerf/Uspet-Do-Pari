extends CharacterBody2D

@onready var body = $SobakaSprite
@onready var left_bite = $AttackArea/left_bite
@onready var right_bite = $AttackArea/right_bite

const SPEED = 150.0
var HP = 10
var STAMINA = 100
var MAX_STAMINA = 100
var ATTACK_WAIT = 30
var detect_player = false
var direction = "left"
var attacking = false
var stand = true
var atk = false
var hitting = false

func ai(player):
	var ang = (self.position-player.position).angle()
	if ang >= -1.5 and ang < 1.5:
		direction = "left"
	else:
		direction = "right"
	if atk and !attacking and !hitting:
		attack(player.position, direction)
	if player.position.distance_to(position) < 300:
		if player.position.distance_to(position) < 30:
			stand = true
			velocity = Vector2(0, 0)
		else:
			stand = false
			if !attacking and !hitting:
				velocity = (player.position - self.position).normalized() * SPEED
	else:
		stand = true
	if !attacking and !hitting:
		if stand:
			body.play("stand_" + direction)
		else:
			body.play("walk_" + direction)

func attack(pl, dir):
	velocity = Vector2(0, 0)
	attacking = true
	body.play("attack_" + direction)
	await get_tree().create_timer(0.15).timeout
	$Bite.play()
	velocity = (pl - self.position).normalized() * SPEED * 4
	await get_tree().create_timer(0.15).timeout
	velocity = Vector2(0, 0)
	if dir == "left":
		left_bite.disabled = false
	else:
		right_bite.disabled = false
	

func _physics_process(delta):
	$HP_BAR.set_size(Vector2(int((HP*16)/10), 1))
	move_and_slide()


func _on_sobaka_sprite_animation_finished():
	if body.animation.begins_with("att"):
		attacking = false
		left_bite.disabled = true
		right_bite.disabled = true
		$AnotherAttack.monitoring = true


func _on_doge_area_entered(area):
	if !hitting:
		var z = false
		if area.is_in_group("fireball"):
			hitting = true
			HP -= 6
			z = true
		elif area.is_in_group("Portfel"):
			HP -= 8
			z = true
			hitting = true
		if z:
			$SobakaSprite.modulate = Color(1, 0.5, 0.5, 1)
			velocity = Vector2(0,0)
			if HP < 0:
				await get_tree().create_timer(0.15).timeout
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
