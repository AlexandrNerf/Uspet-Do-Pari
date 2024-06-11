extends Area2D

var target
var fb = false
@onready var spr = $Cone
var CLOCK = 350
var blocked = false
var blockedpos
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spr.animation == "def":
		if !is_instance_valid(target):
			spr.play("end")
		else:
			if !blocked:
				if fb:
					position += (target.position/2 - position).normalized() * 160 * delta
				else:
					position += (target.position - position).normalized() * 160 * delta
			else:
				position += (blockedpos - position).normalized() * -130 * delta
		CLOCK -= 300 * delta
		if CLOCK < 0:
			$Hitbox.disabled = true
			spr.play("end")

func start():
	spr.play("appear")

func _on_cone_animation_finished():
	if spr.animation == "appear":
		spr.play("def")
	if spr.animation == "end":
		queue_free()




func _on_area_entered(area):
	if area.is_in_group("Player"):
		spr.play("end")
	if area.is_in_group("fireball"):
		spr.play("end")
	if area.is_in_group("Portfel"):
		blockedpos = target.position
		blocked = true
	if area.is_in_group("obj"):
		spr.play("end")

func _on_body_entered(body):
	if body is TileMap:
		spr.play("end")
