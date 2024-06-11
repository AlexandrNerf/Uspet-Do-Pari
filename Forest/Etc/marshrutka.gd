extends Area2D

@onready var t = $Texture
@onready var s = $Sound

var counter = 0
var exati = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exati:
		t.play("edet")
		position -= Vector2(16, 8) * delta * 10
		counter += 1
		if counter > 10000:
			queue_free()
