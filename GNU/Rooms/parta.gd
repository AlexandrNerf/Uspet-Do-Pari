extends Node2D

var enter = false
@onready var main = $MainSprite
@onready var bonus = $BonusSprite
var contains_item = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		enter = true




func _on_area_2d_area_exited(area):
	if area.is_in_group("Player"):
		enter = false
