extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start():
	$DoorSnow.play("default")

func end():
	$DoorSnow.play("end")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_door_snow_animation_finished():
	if $DoorSnow.animation == "end":
		queue_free()
