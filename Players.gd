extends CharacterBody2D

# MAIN DEFINES ------

var SPEED = 120.0
const JUMP_VELOCITY = -400.0

var MAX_HP = 30
var HP = MAX_HP
var MAX_MP = 10
var MP = MAX_MP
var mp_heal = 0
var MAX_STAMINA = 200
var STAMINA = 200
var ROLL_WAIT = 10
var delay_of_run = false
var moving = false
var sliding = false
var direction = "standing_down"
var move_dir = "move_down"
var roll_speed_up = 1

# INCLUDES ------

@onready var _animated_sprite = $AnimatedSprite2D
@onready var box_left = $"HitBoxs/Attack Box Left"
@onready var box_right = $"HitBoxs/Attack Box Right"
@onready var left_sword = $AnimatedSprite2D/left_sword
@onready var right_sword = $AnimatedSprite2D/right_sword
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# MAIN FUNCTIONS ------
func animation_predict(input_direction):
	var rot = get_local_mouse_position().angle()
	
	if rot >= -0.7853 and rot < 0.7853:
		direction = "standing_right"
		move_dir = "move_right"
	elif rot >= 0.7853 and rot < 2.356: 
		direction = "standing_down"
		move_dir = "move_down"
	elif rot >= 2.356 or rot < -2.356:
		direction = "standing_left"
		move_dir = "move_left"
	elif rot >= -2.356 and rot < -0.7853:
		direction = "standing_up"
		move_dir = "move_up"
	if input_direction.x != 0 or input_direction.y != 0:
		moving = true
	else:
		moving = false
		

func get_input():
	if !attacking:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if Input.is_action_pressed("Shift") and delay_of_run == false:
			SPEED = 250
			STAMINA -= 1
			if STAMINA < 2:
				delay_of_run = true
		else:
			SPEED = 150
			STAMINA = min(MAX_STAMINA, STAMINA+1)
			if STAMINA == MAX_STAMINA:
				delay_of_run = false
		animation_predict(input_direction)
		if sliding:
			if roll_speed_up > 1:
				roll_speed_up -= 0.25
		#_animated_sprite.play("standing_right")
		if Input.is_action_just_pressed("Space") and !sliding:
			_animated_sprite.play("slide_right")
			sliding = true
			STAMINA -= 50
			roll_speed_up = 6
		self.velocity = input_direction * SPEED * roll_speed_up

var attacking = false
# MAIN --- 

func _ready():
	pass

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "left_attack" or $AnimatedSprite2D.animation == "right_attack":
		attacking = false
		box_left.disabled = true
		box_right.disabled = true
		left_sword.visible = false
		right_sword.visible = false
		SPEED = 120
	if $AnimatedSprite2D.animation == "slide_right":
		sliding = false

func _physics_process(delta):
	get_input()
	if moving and not attacking and !sliding:
		_animated_sprite.play(move_dir)
	else:
		if !attacking and !sliding:
			_animated_sprite.play(direction)
	if Input.is_action_just_pressed("attack"):
		var angl = get_local_mouse_position().angle()
		if !sliding and !attacking and STAMINA > 30:
			if angl < 1.56 and angl > -1.56:
				_animated_sprite.play("right_attack")
				right_sword.visible = true
				right_sword.play("default")
				box_right.disabled = false
				attacking = true
				STAMINA -= 30
			else:
				_animated_sprite.play("left_attack")
				left_sword.visible = true
				left_sword.play("default")
				box_left.disabled = false
				attacking = true
				STAMINA -= 30
	if !attacking:
		move_and_slide()

	


func _on_area_2d_area_entered(area):
	if area.is_in_group("Slimes"):
		HP -= 3
	pass # Replace with function body.
