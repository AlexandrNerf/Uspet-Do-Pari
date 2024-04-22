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
		position -= Vector2(1.6*3, 0.8*3)
		counter += 1
		if counter > 1000:
			queue_free()
