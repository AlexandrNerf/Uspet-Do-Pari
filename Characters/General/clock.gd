extends AnimatedSprite2D

var time = 0
var transparency = 0.0
var sett = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if time > 0:
		play("minus")
	else:
		play("plus")
	$RichTextLabel.text = str(time) + ' sec'
	sett = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sett:
		position.y -= delta * 8
		modulate = Color(1, 1, 1, transparency)
		transparency += 0.01
		print("clock " + str(transparency))


func _on_animation_finished():
	queue_free()
