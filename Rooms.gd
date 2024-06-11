
class_name Room

var positions
var map_x_y
var index
var monsters = []
var corridors = []
var blocked = false
var closed = false
var ind = 0
var key = 0

var work = false
var key_tego = false
var table
# 0 - right, 1 - left, 2 - up


func is_in_room(pos):
	if pos.x >= positions.position.x+1 and pos.x <= positions.position.x + positions.size.x-1 and pos.y >= positions.position.y+1 and pos.y <= positions.position.y + positions.size.y-1:
		return true
	return false

func blocked_room():
	if monsters.is_empty():
		return false
	return true

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
