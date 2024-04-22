extends CharacterBody2D

@onready var _animated_sprite = $AlexSprite
var clock = preload("res://Characters/General/clock.tscn")
@onready var box = $Hitbox


var dead = false
var SPEED = 150.0
const JUMP_VELOCITY = -400.0
var changing = true
var MAX_HP = 50
var HP = MAX_HP
var MAX_MP = 5
var MP = MAX_MP
var mp_heal = 0
var MAX_STAMINA = 300
var STAMINA = 300
var ROLL_WAIT = 10

var delay_of_run = false
var moving = false
var sprint = false
var attacking = false

var damage_in_seconds = 0
var hitting = false
var now_ball
var direction = "down"

func animation_predict(input_direction):
	var rot = get_local_mouse_position().angle()
	
	if rot >= -0.7853 and rot < 0.7853:
		direction = "right"
	elif rot >= 0.7853 and rot < 2.356: 
		direction = "down"
	elif rot >= 2.356 or rot < -2.356:
		direction = "left"
	elif rot >= -2.356 and rot < -0.7853:
		direction = "up"
	if input_direction.x != 0 or input_direction.y != 0:
		moving = true
	else:
		moving = false

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# sprint
	if Input.is_action_pressed("Shift") and delay_of_run == false:
		SPEED = 250
		STAMINA -= 1
		sprint = true
		if STAMINA < 2:
			delay_of_run = true
	else:
		SPEED = 150
		sprint = false
		STAMINA = min(MAX_STAMINA, STAMINA+1)
		if STAMINA == MAX_STAMINA:
			delay_of_run = false
	animation_predict(input_direction)
	if !onice:
			self.velocity = input_direction * SPEED

func attack(dir):
	$Bum.play()
	if dir == "right":
		$AttackBox/Right.disabled = false
	if dir == "left":
		$AttackBox/Left.disabled = false
	if dir == "up":
		$AttackBox/Up.disabled = false
	if dir == "down":
		$AttackBox/Down.disabled = false

var onice = false

func move():
	if moving and !attacking and !onice:
		if sprint:
			_animated_sprite.play("sprint_" + direction)
			#$Walk.pitch_scale = 2
			#if !$Walk.is_playing():
				#$Walk.play()
		else:
			_animated_sprite.play("move_" + direction)
			#if !$Walk.is_playing():
				#$Walk.pitch_scale = 1.5
				#$Walk.play()
	else:
		if !attacking:
			_animated_sprite.play("standing_" + direction)
			#$Walk.pitch_scale = 1.5
			#$Walk.stop()
			
	

func restore():
	if MP < MAX_MP:
		mp_heal += 1
		if mp_heal >= 100:
			MP += 1
			mp_heal = 0

func _physics_process(delta):
	
	restore()
	
	if !changing and Dialogic.current_timeline == null:
		get_input()
		move()
		if Input.is_action_just_pressed("attack") and !changing and !onice:
			if !attacking and STAMINA > 30 and MP >= 2:
					_animated_sprite.play("attack_" + direction)
					attacking = true
					attack(direction)
					STAMINA -= 50
		if !attacking:
			move_and_slide()


func _on_bodybox_area_entered(area):
	if area.is_in_group("Marsh"):
		dead = true
	if area.is_in_group("Slimes") and !hitting:
		hitting = true
		_animated_sprite.modulate = Color(1, 0.5, 0.5, 1)
		damage_in_seconds = 15
		await get_tree().create_timer(0.5).timeout
		_animated_sprite.modulate = Color(1, 1, 1, 1)
		hitting = false

func _on_alex_sprite_animation_finished():
	if (_animated_sprite.animation).begins_with("attack"):
		attacking = false
		$AttackBox/Right.disabled = true
		$AttackBox/Left.disabled = true
		$AttackBox/Up.disabled = true
		$AttackBox/Down.disabled = true

var new_ice = false

func _on_legs_area_entered(area):
	if area.is_in_group("Ice"):
		onice = true
		await get_tree().create_timer(1.1).timeout
		onice = false


func _on_legs_area_exited(area):
	if area.is_in_group("Ice"):
		pass
		#await get_tree().create_timer(0.15).timeout
		#onice = false
			

