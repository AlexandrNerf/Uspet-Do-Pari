extends Area2D


const SPEED = 150

var MAX_TIME = 50
var time = 0
var created = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Ball.animation == "flight":
		position += transform.x * SPEED * delta
		time += 2
		if time > MAX_TIME:
			$Ball.play("end")
	else:
		if !created:
			position += transform.x * SPEED * delta * 6
			created = true
			$Ball.play("start")


func _on_ball_animation_finished():
	if $Ball.animation == "start":
		$Ball.play("flight")
	if $Ball.animation == "end" or $Ball.animation == "boom":
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("slimes"):
		#$Ball.scale = Vector2(4, 4)
		$Collision.scale = Vector2(2, 2)
		$Ball.play("boom")
		if !$Boom.is_playing():
			$Boom.play()


func _on_body_entered(body):
	if body is TileMap:
		$Ball.play("boom")
		if !$Boom.is_playing():
			$Boom.play()
	pass # Replace with function body.
