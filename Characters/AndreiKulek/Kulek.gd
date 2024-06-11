extends CharacterBody2D

@onready var walk = $Walk

# MAIN DEFINES ------

var SPEED = 150.0
const JUMP_VELOCITY = -400.0
var changing = false
var MAX_HP = 30
var HP = MAX_HP
var MAX_MP = 20
var MP = MAX_MP
var mp_heal = 0
var MAX_STAMINA = 200
var STAMINA = 200
var ROLL_WAIT = 10

var dead = false
var delay_of_run = false
var moving = false
var sprint = false
var onice = false

var damage_in_seconds = 0

var hitting = false
var now_ball
var direction = "down"


var roll_speed_up = 1

# INCLUDES ------

@onready var _animated_sprite = $AndrewSprite
@onready var staff = $AndrewSprite/Staff
@onready var box = $HitBox

var fireball = preload("res://Characters/AndreiKulek/Projectiles/fireball.tscn")
var clock = preload("res://Characters/General/clock.tscn")

# MAIN FUNCTIONS ------
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
		

func get_input(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	$Marker2D.look_at(get_global_mouse_position())
	# sprint
	if Input.is_action_pressed("Shift") and delay_of_run == false:
		SPEED = 250
		STAMINA -= 100 * delta
		sprint = true
		if STAMINA < 2:
			delay_of_run = true
	else:
		SPEED = 150
		sprint = false
		STAMINA = min(MAX_STAMINA, STAMINA+150*delta)
		if STAMINA == MAX_STAMINA:
			delay_of_run = false
	animation_predict(input_direction)
	if !onice:
		self.velocity = input_direction * SPEED

var attacking = false

# MAIN --- 

func shoot():
	var b = fireball.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Marker2D.global_transform
	MP -= 2
	now_ball = b

func _ready():
	pass

func restoring():
	if MP < MAX_MP:
		mp_heal += 1
		if mp_heal >= 30:
			MP += 2
			mp_heal = 0

func move():
	if moving and !attacking and !onice:
		staff.play("standing_" + direction)
		if sprint:
			_animated_sprite.play("sprint_" + direction)
			staff.play("standing_" + direction)
			$Walk.pitch_scale = 2
			if !$Walk.is_playing():
				$Walk.play()
		else:
			_animated_sprite.play("move_" + direction)
			staff.play("standing_" + direction)
			if !$Walk.is_playing():
				$Walk.pitch_scale = 1.5
				$Walk.play()
	else:
		if !attacking:
			_animated_sprite.play("standing_" + direction)
			staff.play("standing_" + direction)
			if !onice:
				$Walk.pitch_scale = 1.5
				$Walk.stop()

func jump():
	await get_tree().create_timer(0.03).timeout
	position += Vector2(5, -2)
	await get_tree().create_timer(0.03).timeout
	position += Vector2(6, -2)
	await get_tree().create_timer(0.03).timeout
	position += Vector2(8, -2)
	await get_tree().create_timer(0.03).timeout
	position += Vector2(10, -2)
	await get_tree().create_timer(0.03).timeout
	position += Vector2(8, 2)
	await get_tree().create_timer(0.03).timeout
	position += Vector2(7, 2)
	await get_tree().create_timer(0.03).timeout
	position += Vector2(4, 2)
	await get_tree().create_timer(0.03).timeout
	position += Vector2(2, 2)
	

func _physics_process(delta):
	
	if changing:
		restoring()
	
	if !changing and Dialogic.current_timeline == null:
		get_input(delta)
		move()
		if Input.is_action_just_pressed("attack"):
			if !attacking and STAMINA > 30 and MP >= 2:
					shoot()
					_animated_sprite.play("attacking_" + direction)
					staff.play("attacking_" + direction)
					attacking = true
					STAMINA -= 30
		move_and_slide()


func _on_area_2d_area_entered(area):
	if area.is_in_group("Marsh"):
		dead = true
	elif area.is_in_group("Slimes") and !hitting:
		hitting = true
		$AndrewSprite.modulate = Color(1, 0.5, 0.5, 1)
		damage_in_seconds = 15
		await get_tree().create_timer(0.5).timeout
		$AndrewSprite.modulate = Color(1, 1, 1, 1)
		hitting = false
	elif area.is_in_group("tegovir_attacks") and !hitting:
		hitting = true
		$AndrewSprite.modulate = Color(1, 0.5, 0.5, 1)
		damage_in_seconds = 20
		await get_tree().create_timer(0.5).timeout
		$AndrewSprite.modulate = Color(1, 1, 1, 1)
		hitting = false
	elif area.is_in_group("Cone") and !hitting:
		hitting = true
		$AndrewSprite.modulate = Color(1, 0.5, 0.5, 1)
		damage_in_seconds = 7
		await get_tree().create_timer(0.5).timeout
		$AndrewSprite.modulate = Color(1, 1, 1, 1)
		hitting = false

func _on_andrew_sprite_animation_finished():
	if ($AndrewSprite.animation).begins_with("attack"):
		attacking = false


func _on_legs_area_entered(area):
	if area.is_in_group("Ice"):
		onice = true
		await get_tree().create_timer(1.1).timeout
		onice = false


func _on_legs_area_exited(area):
	if area.is_in_group("Ice"):
		pass
