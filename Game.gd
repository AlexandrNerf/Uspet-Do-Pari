extends Node2D

####
# ONREADY VARIABLES
####

@onready var tileMap = $TileMap
@onready var player = $AndreiKulek
@onready var GUI_Canvas = $GUI_Canvas
@onready var miniMap = $GUI_Canvas/Control/SubViewportContainer/SubViewport/Mini/MiniMap
@onready var minic = $GUI_Canvas/Control/SubViewportContainer/SubViewport/Mini/MiniChar
@onready var warner = $GUI_Canvas/PUSHING

####
# MONSTERS
####

var doge = preload("res://Monsters/Dog/sobaka.tscn")
var borya = preload("res://Monsters/Borya/borya.tscn")
var belka = preload("res://Monsters/Belka/belka.tscn")

####
# ETC
####
var clock = preload("res://Characters/General/clock.tscn")
var ice_floor = preload("res://Forest/Misc/ice.tscn")
var marshr = preload("res://Forest/Etc/marshrutka.tscn")
var gnu_ent = preload("res://GNU/gnu.tscn")
var snow_door = preload('res://Forest/Misc/door_snows.tscn')
var tegovir = preload("res://Monsters/Tegovir/tegovir.tscn")

####
# ROOMS FOR FOREST
####

var r1 = preload("res://Forest/Rooms/room1.tscn")
var r2 = preload("res://Forest/Rooms/room2.tscn")
var r3 = preload("res://Forest/Rooms/room_3.tscn")

####
# ROOMS FOR GNU
####
var gnur1 = preload("res://GNU/Rooms/room_gnu.tscn")


####
# CONSTANTS
####
const LEVEL_SIZE = Vector2(600, 600)
const TILE_SIZE = 32
const FOREST_LEVEL_ROOM_COUNTS = [0, 12, 12, 12, 12, 8, 12]


####
# GENERAL VARIABLES
####

# KEYS

var my_work = false
var my_key = false

# LEVELS
var gnu = false
var metro = false
var forest = true
var level_num = 3

# EVERYTHING TO DELETE
var deletable_things = []

# TEXT SHOW
var warn = false
var dial = false
var dialogue = true


####
# GNU VARIABLES
####

var boss_init = false
var tegovir_room
var hall_metro = []
var map_nsu = []
var hall_nsu = []
var keys = []
var pos_keys = [4202, 4213, 4211, 4200, 4232, 4212, 4220, 4140, 4206, 4205]
var pos_keys_2 = [4202, 4213, 4211, 4200, 4232, 4212, 4220, 4140, 4206, 4205]
var gnu_enter

#########
# FOREST VARIABLES
#########

var map = []
var rooms = []
var is_marsh = true
var curr_marshr
var animating = true 
var curr_doors = []
var road1
var road2
var stair_coords

####
# METRO VARIABLES
####

var map_metro = []
var map_cells = []

####
# SPRITES
####

const WALL = Vector3i(5, 0, 0)
const BLOCK_WALL = Vector3i(12, 0, 0)
# Пол
const FLOOR = Vector3i(30, 0, 0)
const FLOOR_2 = Vector3i(6, 0, 0)
const GNU_FLOOR = Vector3i(50, 0, 0)
const GNU_WALL = Vector3i(60, 0, 0)
const GNU_WALL_ROOM = Vector3i(61, 0, 0)
# Общая стена
const M_WALL = Vector3i(5, 0, 0)
const NONE = Vector3i(0, 0, 0)
const FOG = Vector3i(18, 0, 0)


####
# MAP DRAW AND SHOW FUNCTIONS, ISOMETRIC
####

func set_tile(x, y, type):
	var typical_z = 0
	
	if type == GNU_FLOOR:
		tileMap.set_cell(1, Vector2i(floor(float(x)/2 - float(y)/2), y + x), -1)
		tileMap.set_cell(0, Vector2i(floor(float(x)/2 - float(y)/2), y + x), 50, Vector2(type.y, type.z))
	elif type == GNU_WALL:
		tileMap.set_cell(1, Vector2i(floor(float(x)/2 - float(y)/2), y + x), 60, Vector2(type.y+randi()%5, type.z))
	elif type == GNU_WALL_ROOM:
		tileMap.set_cell(1, Vector2i(floor(float(x)/2 - float(y)/2), y + x), 60, Vector2(type.y+randi()%3, type.z))
	elif type == FLOOR:
		tileMap.set_cell(1, Vector2i(floor(float(x)/2 - float(y)/2), y + x), -1)
		tileMap.set_cell(0, Vector2i(floor(float(x)/2 - float(y)/2), y + x), 30+randi()%4, Vector2(type.y, type.z))
	elif type == WALL:
		tileMap.set_cell(1, Vector2i(floor(float(x)/2 - float(y)/2), y + x), 40+randi()%3, Vector2(type.y, type.z))
	else:
		#if type.x == 12:
			#set_door(x, y)
		#else:
		miniMap.set_cell(0, Vector2i(floor(float(x)/2 - float(y)/2), y + x), type.x, Vector2i(type.y, type.z))
		tileMap.set_cell(typical_z, Vector2i(floor(float(x)/2 - float(y)/2), y + x), type.x, Vector2i(type.y, type.z))


func iso_tile(x, y):
	return Vector2i(floor(float(x)/2 - float(y)/2), y + x)

func convert_to_iso(x, y):
	return Vector2((x)*32 - (y)*32 + 32, (y)*16 + (x)*16)

# for objects
func isom(x, y):
	return Vector2((x)*32 - (y)*32 + 32, (y)*16 + (x)*16 + 16)

####
# ROOMS AND LEVEL INITS
####

func set_door(x, y):
	var door = snow_door.instantiate()
	add_child(door)
	door.position = convert_to_iso(x, y)
	door.start()
	curr_doors.append(door)

func dig_room_metro(xt, yt):
	var new_room = Room.new()
	
	
	if xt == 1:
		xt = 26
		
	new_room.positions = Rect2(Vector2(xt, 16*yt+2), Vector2(14, 10))
	#new_room.right = true
	# add on map and etc
	if xt == 26:
		xt = 1
	new_room.corridors.append(xt)
	new_room.map_x_y = Vector2(xt, yt)
	
	rooms.append(new_room)
	
	map_metro[xt][yt] = rooms.size()
	rooms[rooms.size()-1].index = rooms.size()
	
	# set room
	for x in range(new_room.positions.position.x, new_room.positions.position.x + new_room.positions.size.x +1):
		for y in range(new_room.positions.position.y, new_room.positions.position.y + new_room.positions.size.y+1):
			if x == new_room.positions.position.x or x == new_room.positions.position.x + new_room.positions.size.x or y == new_room.positions.position.y or y == new_room.positions.position.y + new_room.positions.size.y:
				set_tile(x, y, WALL)
			else:
				set_tile(x, y, FLOOR)
			if rooms.size() > 1:
				tileMap.set_cell(3, iso_tile(x, y), FOG.x, Vector2i(FOG.y, FOG.z))
			else:
				tileMap.set_cell(3, iso_tile(x, y), -1)

func create_level_metro():
	for x in range(31):
		map_metro.append([])
		hall_metro.append(0)
		for y in range(31):
			map_metro[x].append(0)
	var fst = randi() % 2
	dig_corridor_nsu(30)
	var r = dig_room_metro(0, 30)
	dig_doors(0, 30)
	for room in rooms:
		if rooms.size() > 20:
			break
		var pos = room.map_x_y
		var count = 0
		while count != 1:
			var room_side = randi() % 2
			if room_side == 0:
				if map_metro[pos.x][pos.y-1] == 0:
					if hall_metro[pos.y-1] == 0:
						dig_corridor_nsu(pos.y-1)
					dig_room_metro(pos.x, pos.y-1)
					dig_doors(pos.x, pos.y-1)
					count += 1
			else:
				var new_p = 1
				if pos.x == 1:
					pass
				if map_metro[new_p][pos.y] == 0:
					dig_room_metro(new_p, pos.y)
					dig_doors(new_p, pos.y)
					count += 1


##########
# FOREST FUNCTIONS
####

func forest_ready():
	
	# main function
	create_level_forest()
	
	
	forest = true
	
	# create player
	
	# process monsters
	
	for room in rooms:
		if room == rooms.front() or room == rooms.back():
			continue
		var rand_room = randi() % 3
		if rand_room == 0:
			process_room_1(room)
		elif rand_room == 1:
			process_room_2(room)
		else:
			process_room_3(room)
		# test
		
	
	# set road and inits start game intro
	if level_num == 3:
		player.visible = false
		GUI_Canvas.visible = false
		var start_room = rooms.front()
		var player_start_coords = Vector2(start_room.positions.position.x + 8, start_room.positions.position.y + 11)
		player.position = isom(player_start_coords.x, player_start_coords.y)
		$CanvasModulate/PointLight2D.position = player.position
		set_road(rooms.front())
		
	if level_num == 4:
		var start_room = rooms.front()
		var player_start_coords = Vector2(start_room.positions.position.x + 8, start_room.positions.position.y + 7)
		player.position = isom(player_start_coords.x, player_start_coords.y)
		gnu_enter = gnu_ent.instantiate()
		add_child(gnu_enter)
		gnu_enter.position = isom(rooms.back().positions.position.x, rooms.back().positions.position.y)
		gnu_enter.position += Vector2(174, 96)
		for x in range(rooms.back().positions.position.x+2, rooms.back().positions.position.x+14):
			set_tile(x, rooms.back().positions.position.y, GNU_FLOOR)

func create_level_forest():
	# map init
	for x in range(51):
		map.append([])
		for y in range(51):
			map[x].append(0)
	
	var start_x = 15
	var start_y = 30
	var r = dig_room(start_x, start_y)
	
	for room in rooms:
		if rooms.size() > FOREST_LEVEL_ROOM_COUNTS[level_num]:
			break
		var pos_room = room.map_x_y
		var now_rooms = rooms.size()
		var not_ways = 0
		if map[pos_room.x+1][pos_room.y] != 0:
			not_ways += 1
		if map[pos_room.x-1][pos_room.y] != 0:
			not_ways += 1
		if map[pos_room.x][pos_room.y-1] != 0:
			not_ways += 1
		var max_ways = 3 - not_ways
		if max_ways == 0:
			continue
		var ways = 1 + randi() % (max_ways)
		if room == rooms.front():
			ways = 1
		
		while rooms.size() < now_rooms + ways and rooms.size() < FOREST_LEVEL_ROOM_COUNTS[level_num]:
			var direction_dig = randi() % 3
			if room == rooms.front() or rooms.size() == FOREST_LEVEL_ROOM_COUNTS[level_num]-1:
				if pos_room.y-1 >= 0 and map[pos_room.x][pos_room.y-1] == 0:
					direction_dig = 2
				else:
					break
			match direction_dig:
				# right
				0:
					if pos_room.x+1 < 50 and map[pos_room.x+1][pos_room.y] == 0:
						r = dig_room(pos_room.x+1, pos_room.y)
						dig_corridor(0, room)
						room.corridors.append(0)
						r.corridors.append(1)
						#print("Created in 0 state room", rooms.size()-1)
				# left
				1:
					if pos_room.x-1 >= 0 and map[pos_room.x-1][pos_room.y] == 0:
						r = dig_room(pos_room.x-1, pos_room.y)
						dig_corridor(1, room)
						room.corridors.append(1)
						r.corridors.append(0)
						#print("Created in 1 state room", rooms.size()-1)
				# up
				2: 
					if pos_room.y-1 >= 0 and map[pos_room.x][pos_room.y-1] == 0:
						r = dig_room(pos_room.x, pos_room.y-1)
						dig_corridor(3, room)
						room.corridors.append(3)
						r.corridors.append(2)
						#print("Created in 2 state room", rooms.size()-1)

func dig_room(xt, yt):
	# create room class
	var new_room = Room.new()
	new_room.positions = Rect2(Vector2(xt*20+4, yt*20+2), Vector2(16, 12))
	
	# add on map and etc
	new_room.map_x_y = Vector2(xt, yt)
	rooms.append(new_room)
	map[xt][yt] = rooms.size()
	rooms[rooms.size()-1].index = rooms.size()
	
	# set room
	for x in range(new_room.positions.position.x, new_room.positions.position.x + new_room.positions.size.x +1):
		for y in range(new_room.positions.position.y, new_room.positions.position.y + new_room.positions.size.y+1):
			if x == new_room.positions.position.x or x == new_room.positions.position.x + new_room.positions.size.x or y == new_room.positions.position.y or y == new_room.positions.position.y + new_room.positions.size.y:
				set_tile(x, y, WALL)
			else:
				set_tile(x, y, FLOOR)
			if rooms.size() > 1:
				if rooms.size() == FOREST_LEVEL_ROOM_COUNTS[level_num] and y > new_room.positions.position.y + 4:
					pass
				else:
					if level_num == 4 and rooms.size() == FOREST_LEVEL_ROOM_COUNTS[level_num]:
						pass
					else:
						tileMap.set_cell(3, iso_tile(x, y), FOG.x, Vector2i(FOG.y, FOG.z))
			else:
				tileMap.set_cell(3, iso_tile(x, y), -1)
	return rooms[rooms.size()-1]

func dig_corridor(dir, room):
	# 0 - right, 1 - left, 2 - down, 3 - up
	match dir:
		0:
			for x in range(room.positions.position.x+16, room.positions.position.x+16+4+1):
				for y in range(room.positions.position.y+4, room.positions.position.y+4+4+1):
					if y == room.positions.position.y+4 or y == room.positions.position.y+8:
						set_tile(x, y, WALL)
					else:
						set_tile(x, y, FLOOR)
					tileMap.set_cell(3, iso_tile(x, y), -1)
		1:
			for x in range(room.positions.position.x-4, room.positions.position.x+1):
				for y in range(room.positions.position.y+4, room.positions.position.y+4+4+1):
					if y == room.positions.position.y+4 or y == room.positions.position.y+8:
						set_tile(x, y, WALL)
					else:
						set_tile(x, y, FLOOR)
					tileMap.set_cell(3, iso_tile(x, y), -1)
		2: 
			for x in range(room.positions.position.x+6, room.positions.position.x+10+1):
				for y in range(room.positions.position.y+12, room.positions.position.y+12+8+1):
					if x == room.positions.position.x+6 or x == room.positions.position.x+10:
						set_tile(x, y, WALL)
					else:
						set_tile(x, y, FLOOR)
					tileMap.set_cell(3, iso_tile(x, y), -1)
		3:
			for x in range(room.positions.position.x+6, room.positions.position.x+10+1):
				for y in range(room.positions.position.y-8, room.positions.position.y+1):
					if x == room.positions.position.x+6 or x == room.positions.position.x+10:
						set_tile(x, y, WALL)
					else:
						set_tile(x, y, FLOOR)
					tileMap.set_cell(3, iso_tile(x, y), -1)

####
# FOREST ROOMS INIT
####

func process_room_1(room):
	var nr = r1.instantiate()
	add_child(nr)
	deletable_things.append(nr)
	nr.position = isom(room.positions.position.x, room.positions.position.y)
	var add_arr = [Vector2(2, 2), Vector2(7, 2), Vector2(12, 2), Vector2(12, 5), Vector2(2, 5), Vector2(2, 7), Vector2(5, 7), Vector2(12, 7)]
	for i in range(8):
		var dog = doge.instantiate()
		add_child(dog)
		var dp = room.positions.position + add_arr[i]
		dog.position = isom(dp.x, dp.y)
		room.monsters.append(dog)

func process_room_2(room):
	var nr = r2.instantiate()
	add_child(nr)
	deletable_things.append(nr)
	nr.position = isom(room.positions.position.x, room.positions.position.y)
	var add_arr = [Vector2(2, 2), Vector2(7, 2), Vector2(12, 2), Vector2(12, 5), Vector2(2, 5), Vector2(5, 7)]
	for i in range(6):
		if i == 1:
			var belk = belka.instantiate()
			add_child(belk)
			var dp = room.positions.position + add_arr[i]
			belk.position = isom(dp.x, dp.y)
			room.monsters.append(belk)
		else:
			var dog = doge.instantiate()
			add_child(dog)
			var dp = room.positions.position + add_arr[i]
			dog.position = isom(dp.x, dp.y)
			room.monsters.append(dog)

func process_room_3(room):
	var nr = r3.instantiate()
	add_child(nr)
	deletable_things.append(nr)
	nr.position = isom(room.positions.position.x, room.positions.position.y)
	var add_arr = [Vector2(1, 1), Vector2(13, 1), Vector2(13, 9), Vector2(1, 9), Vector2(6, 5)]
	for i in range(5):
		var belk = belka.instantiate()
		add_child(belk)
		var dp = room.positions.position + add_arr[i]
		belk.position = isom(dp.x, dp.y)
		room.monsters.append(belk)


####
# START ANIMATION FUNCTION
####

func set_road(roomz):
	
	var roads = roomz
	# DRAW EXTERNAL MAP
	for x in range(roads.positions.position.x, roads.positions.position.x + roads.positions.size.x + 1):
		for y in range(roads.positions.position.y + 11, roads.positions.position.y + roads.positions.size.y + 1):
			set_tile(x, y, FLOOR)
	
	for x in range(roads.positions.position.x - 100, roads.positions.position.x + 100):
		if x > roads.positions.position.x + 5 and x < roads.positions.position.x + 12:
			var y2 = roads.positions.position.y + roads.positions.size.y + 4
			set_tile(x, y2, FLOOR)
			set_tile(x, y2+1, WALL)
			set_tile(x, y2+2, WALL)
			set_tile(x, y2+3, WALL)
			continue
		var y = roads.positions.position.y + roads.positions.size.y - 1
		var y2 = roads.positions.position.y + roads.positions.size.y + 4
		set_tile(x, y, WALL)
		set_tile(x, y+1, FLOOR)
		set_tile(x, y+3, FLOOR)
		set_tile(x, y2, FLOOR)
		set_tile(x, y2+1, WALL)
		set_tile(x, y2+2, WALL)
		set_tile(x, y2+3, WALL)
	
	
	var start_x = roads.positions.position.x + 8
	var start_y = roads.positions.position.y + 13
	var start_x1 = roads.positions.position.x + 8
	var start_y1 = roads.positions.position.y + 15
	
	road1 = preload("res://Forest/Misc/road.tscn").instantiate()
	var road2 = preload("res://Forest/Misc/road.tscn").instantiate()
	add_child(road1)
	add_child(road2)
	road1.position = isom(start_x, start_y) 
	road2.position = isom(start_x1, start_y1)
	
	# ADD ROAD TO DT
	deletable_things.append(road1)
	deletable_things.append(road2)
	
	var m = marshr.instantiate()
	add_child(m)
	
	m.position = isom(start_x, start_y)
	#print(m.position)
	
	
	# animation
	$AndreiKulek/Camera2D.zoom = Vector2(1, 1)
	$CanvasModulate/PointLight2D.texture_scale = 1
	var endpos = m.position
	curr_marshr = m
	m.position += Vector2(384, 192)
	#print(m.position)
	player.visible = false
	player.changing = true
	m.t.play("edet")
	m.s.play()
	while m.position > endpos:
		m.position -= Vector2(6.4, 3.2)
		await get_tree().create_timer(0.05).timeout
		
	m.s.stop()
	m.t.play("stoit")
	
	await get_tree().create_timer(1).timeout
	
	player.visible = true
	
	await get_tree().create_timer(1.5).timeout
	
	m.t.play("edet")
	m.s.play()
	endpos -= Vector2(384, 192)
	while m.position > endpos:
		m.position -= Vector2(6.4, 3.2)
		await get_tree().create_timer(0.05).timeout
		
	m.s.stop()
	#print(m.position)
	m.queue_free()
	animating = false
	
	while $AndreiKulek/Camera2D.zoom < Vector2(2, 2):
		$AndreiKulek/Camera2D.zoom += Vector2(0.05, 0.05)
		await get_tree().create_timer(0.05).timeout
	
	# DIALOG START
	inputable = false
	Dialogic.start("VMetro")
	get_viewport().set_input_as_handled()
	Dialogic.signal_event.connect(_on_dialogic_signal)

var room_blocking_started = false

func block_room_forest(room):
	if !room_blocking_started:
		room_blocking_started = true
		for i in room.corridors:
			match i:
				0:
					set_door(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2-1)
					set_door(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2)
					set_door(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2+1)
				1:
					set_door(room.positions.position.x, room.positions.position.y + room.positions.size.y/2-1)
					set_door(room.positions.position.x, room.positions.position.y + room.positions.size.y/2)
					set_door(room.positions.position.x, room.positions.position.y + room.positions.size.y/2+1)
				2:
					set_door(room.positions.position.x + room.positions.size.x/2 + 1, room.positions.position.y + room.positions.size.y)
					set_door(room.positions.position.x + room.positions.size.x/2, room.positions.position.y + room.positions.size.y)
					set_door(room.positions.position.x + room.positions.size.x/2 - 1, room.positions.position.y + room.positions.size.y)
				3:
					set_door(room.positions.position.x + room.positions.size.x/2 + 1, room.positions.position.y)
					set_door(room.positions.position.x + room.positions.size.x/2, room.positions.position.y)
					set_door(room.positions.position.x + room.positions.size.x/2 - 1, room.positions.position.y)
				_:
					pass

func create_marshr():
	while level_num == 3:
		curr_marshr = marshr.instantiate()
		add_child(curr_marshr)
		curr_marshr.position = Vector2(-9280, 15040)
		curr_marshr.exati = true
		await get_tree().create_timer(30).timeout

########
# GNU LEVEL INIT
####

func nsu_ready():
	gnu = true
	forest = false

	# main function
	create_level_nsu()
	
	$AlexandrUtkin.walk.stream = load("res://Music/Players/WalkNgu.mp3")
	$AndreiKulek.walk.stream = load("res://Music/Players/WalkNgu.mp3")
	
	for room in rooms:
		doors_gnu(0, room)
		room.closed = true
		
	while rooms.size() > 10:
		rooms.remove_at(randi()%rooms.size())
	player.position = Vector2i(-15133.96, 8210.935)
	var i = 0
	for room in rooms:
		var rnd = randi() % pos_keys.size()
		while pos_keys[rnd] not in pos_keys_2:
			rnd = randi() % pos_keys.size()
		room.ind = pos_keys[rnd]
		if room.ind == pos_keys.back():
			room.key = -1
			room.key_tego = true
		else:
			room.key = pos_keys[rnd+1]
		if i == 0:
			room.work = true
		pos_keys_2.erase(pos_keys[rnd])
		i += 1
	keys.append(pos_keys.front())
	print(keys)
	for room in rooms:
		print("KEY: ", room.key)
		print("INDEX: ", room.ind)
		var rand_room = 1
		process_gnu_room_1(room)
	#player.position = isom(121, 416)
	tegovir_room = dig_boss_room()

func process_gnu_room_1(room):
	var nr = gnur1.instantiate()
	add_child(nr)
	deletable_things.append(nr)
	nr.position = isom(room.positions.position.x, room.positions.position.y)
	var add_arr = [Vector2(2, 2), Vector2(2, 5), Vector2(5, 5), Vector2(6, 7), Vector2(9, 3)]
	for i in range(5):
		var dog = borya.instantiate()
		add_child(dog)
		var dp = room.positions.position + add_arr[i]
		dog.position = isom(dp.x, dp.y)
		room.monsters.append(dog)
	var table_pos = room.positions.position + Vector2(6, 2)
	var tables = preload("res://GNU/Rooms/big_parta.tscn")
	var t = tables.instantiate()
	add_child(t)
	if room.work:
		print("work is found in room", room.ind)
		t.bonus.play("work")
	else:
		t.bonus.play("key")
	t.position = isom(table_pos.x, table_pos.y)
	room.table = t

func dig_full_hall_nsu():
	for y in range(26, 31):
		dig_corridor_nsu(y)
	var yt = 26*16+3
	var xt = 6
	var cel = 0
	for x in range(17, 28):
		for y in range(yt-7, yt):
			if y == yt-7 or  x == 17:
				set_tile(x, y, GNU_WALL)
			else:
				set_tile(x, y, GNU_FLOOR)
	for x in range(1, 7):
		vert_corridor(x)

func dig_all_room_nsu():
	# initing rooms of nsu
	for x in range(0, 2):
		for y in range(26, 31):
			dig_room_nsu(x, y)
			dig_door_nsu(x, y)
	for x in range(2, 7):
		vertic_room(x, 0)
		vertic_corr(x, 0)
		vertic_room(x, 1)
		vertic_corr(x, 1)

# main create gnu function
func create_level_nsu():
	for x in range(31):
		map_nsu.append([])
		#hall_nsu.append(0)
		for y in range(31):
			map_nsu[x].append(0)
	dig_full_hall_nsu()
	dig_all_room_nsu()


####
# GNU DOORS
####

# open/close doors
func doors_gnu(open, room):
	if !open:
		#print(room.corridors)
		if room.corridors[0] == 0:
			var x = room.positions.position.x + room.positions.size.x
			var y = room.positions.position.y + room.positions.size.y/2-1
			tileMap.set_cell(2, iso_tile(x, y), 70, Vector2(0, 1))
			tileMap.set_cell(1, iso_tile(x, y), 71, Vector2(0, 1))
		elif room.corridors[0] == 1:
			var x = room.positions.position.x
			var y = room.positions.position.y + room.positions.size.y/2
			tileMap.set_cell(2, iso_tile(x, y), 70, Vector2(0, 0))
			tileMap.set_cell(1, iso_tile(x, y), 71, Vector2(0, 0))
		elif room.corridors[0] == 2:
			var x = room.positions.position.x + room.positions.size.x/2-1
			var y = room.positions.position.y + room.positions.size.y
			tileMap.set_cell(1, iso_tile(x, y), 70, Vector2(0, 3))
			tileMap.set_cell(4, iso_tile(x, y), 71, Vector2(0, 3))
		elif room.corridors[0] == 3:
			var x = room.positions.position.x + room.positions.size.x/2
			var y = room.positions.position.y
			tileMap.set_cell(1, iso_tile(x, y), 70, Vector2(0, 2))
			tileMap.set_cell(4, iso_tile(x, y), 71, Vector2(0, 2))
	else:
		if room.corridors[0] == 0:
			var x = room.positions.position.x + room.positions.size.x
			var y = room.positions.position.y + room.positions.size.y/2-1
			tileMap.set_cell(2, iso_tile(x, y), 70, Vector2(1, 1))
			tileMap.set_cell(1, iso_tile(x, y), 71, Vector2(1, 1))
		elif room.corridors[0] == 1:
			var x = room.positions.position.x
			var y = room.positions.position.y + room.positions.size.y/2
			tileMap.set_cell(2, iso_tile(x, y), 70, Vector2(1, 0))
			tileMap.set_cell(1, iso_tile(x, y), 71, Vector2(1, 0))
		elif room.corridors[0] == 2:
			var x = room.positions.position.x + room.positions.size.x/2-1
			var y = room.positions.position.y + room.positions.size.y
			tileMap.set_cell(1, iso_tile(x, y), 70, Vector2(1, 3))
			tileMap.set_cell(4, iso_tile(x, y), 71, Vector2(1, 3))
		elif room.corridors[0] == 3:
			var x = room.positions.position.x + room.positions.size.x/2
			var y = room.positions.position.y
			tileMap.set_cell(1, iso_tile(x, y), 70, Vector2(1, 2))
			tileMap.set_cell(4, iso_tile(x, y), 71, Vector2(1, 2))
		room.closed = false

####
# EXTENTION FUNCTIONS TO DIG DOORS, ROOMS AND CORRIDORS IN GNU
####

func dig_corridor_nsu(y):
	for yt in range(y*16, y*16+17):
		for x in range(17, 17+6+1):
			if x == 17 or x == 17+6 or (y == 30 and yt == y*16+16):
				set_tile(x, yt, GNU_WALL)
			else:
				set_tile(x, yt, GNU_FLOOR)

func dig_doors(xt, yt):
	var cel = 0
	if xt == 1:
		cel += 9
	for x in range(14+cel, 16+cel+2):
		for y in range(yt*16+5, yt*16+6+2+1):
			if y == yt*16+5 or y == yt*16+8:
				set_tile(x, y, WALL)
			else:
				set_tile(x, y, FLOOR)
			tileMap.set_cell(3, iso_tile(x, y), -1)

func dig_door_nsu(xt, yt):
	var cel = 0
	if xt == 1:
		cel += 6
	var x = 16+cel+1
	for y in range(yt*16+5, yt*16+6+2+1):
		if y == yt*16+5 or y == yt*16+8:
			set_tile(x, y, GNU_WALL_ROOM)
		else:
			set_tile(x, y, GNU_FLOOR)
		tileMap.set_cell(3, iso_tile(x, y), -1)

func dig_room_nsu(xt, yt):
	var new_room = Room.new()
	
	if xt == 1:
		xt = 20
		
	new_room.positions = Rect2(Vector2(xt+3, 16*yt+2), Vector2(14, 10))
	#new_room.right = true
	# add on map and etc
	if xt == 20:
		xt = 1
	new_room.map_x_y = Vector2(xt, yt)
	new_room.corridors.append(xt)
	rooms.append(new_room)
	
	map_nsu[xt][yt] = rooms.size()
	rooms[rooms.size()-1].index = rooms.size()
	
	# set room
	for x in range(new_room.positions.position.x, new_room.positions.position.x + new_room.positions.size.x +1):
		for y in range(new_room.positions.position.y, new_room.positions.position.y + new_room.positions.size.y+1):
			if x == new_room.positions.position.x or x == new_room.positions.position.x + new_room.positions.size.x or y == new_room.positions.position.y or y == new_room.positions.position.y + new_room.positions.size.y:
				set_tile(x, y, GNU_WALL_ROOM)
			else:
				set_tile(x, y, GNU_FLOOR)
				tileMap.set_cell(3, iso_tile(x, y), FOG.x+1, Vector2i(FOG.y, FOG.z))

####
# FOR HALL
####

func vert_corridor(xx):
	var yt = 26*16+3
	var xt = 23 + (xx-1)*16
	for x in range(xt, 23 + xx*16+1):
		for y in range(yt-7, yt):
			if y == yt-7 or y == yt-1:
				set_tile(x, y, GNU_WALL)
			else:
				set_tile(x, y, GNU_FLOOR)

####
# BOSS ROOM DIG
####

func dig_boss_room():
	var x_beg = 120
	var y_beg = 408
	var new_room = Room.new()
	new_room.positions = Rect2(Vector2(120, 408), Vector2(30, 20))
	# set room
	for x in range(new_room.positions.position.x, new_room.positions.position.x + new_room.positions.size.x +1):
		for y in range(new_room.positions.position.y, new_room.positions.position.y + new_room.positions.size.y+1):
			if x == new_room.positions.position.x or x == new_room.positions.position.x + new_room.positions.size.x or y == new_room.positions.position.y or y == new_room.positions.position.y + new_room.positions.size.y:
				if y == 416 or y == 415:
					set_tile(x, y, GNU_FLOOR)
				else:
					set_tile(x, y, GNU_WALL_ROOM)
			else:
				set_tile(x, y, GNU_FLOOR)
	tileMap.set_cell(2, iso_tile(120, 416), 70, Vector2(0, 0))
	#tileMap.set_cell(1, iso_tile(120, 415), 71, Vector2(0, 0))
	return new_room


####
# FOR ROOMS
####

func vertic_corr(xt, yt):
	var cor = 0
	if yt == 0:
		cor = -6
	var start_x = 31+(xt-1)*16
	var y = 16*26+2 + cor
	for x in range(start_x, start_x+4):
			if x == start_x or x == start_x + 3:
				set_tile(x, y, GNU_WALL_ROOM)
			else:
				set_tile(x, y, GNU_FLOOR)
	#new_room.positions = Rect2(Vector2(26+(xt-1)*16, 16*26+2), Vector2(14, 10))

func vertic_room(xt, yt):
	
	# bias
	var col = 0
	if yt == 0:
		col = -16
	var new_room = Room.new()
	
	
	new_room.positions = Rect2(Vector2(26+(xt-1)*16, 16*26+col+2), Vector2(14, 10))
	new_room.closed = true
	#new_room.right = true
	# add on map and etc
	new_room.map_x_y = Vector2(xt, 25)
	if yt == 0:
		new_room.corridors.append(2)
	else:
		new_room.corridors.append(3)
	rooms.append(new_room)
	
	#map_metro[xt][yt] = rooms.size()
	rooms[rooms.size()-1].index = rooms.size()
	
	# set room
	for x in range(new_room.positions.position.x, new_room.positions.position.x + new_room.positions.size.x +1):
		for y in range(new_room.positions.position.y, new_room.positions.position.y + new_room.positions.size.y+1):
			if x == new_room.positions.position.x or x == new_room.positions.position.x + new_room.positions.size.x or y == new_room.positions.position.y or y == new_room.positions.position.y + new_room.positions.size.y:
				set_tile(x, y, GNU_WALL_ROOM)
			else:
				set_tile(x, y, GNU_FLOOR)
				# SET DARKNESS
				if rooms.size() > 1:
					tileMap.set_cell(3, iso_tile(x, y), FOG.x+1, Vector2i(FOG.y, FOG.z))
				else:
					tileMap.set_cell(3, iso_tile(x, y), -1)


####
# PREPARING LEVEL
####

func clear_all():
	for i in deletable_things:
		if is_instance_valid(i):
			i.queue_free()
	deletable_things.clear()
	tileMap.clear()
	map.clear()
	for room in rooms:
		for monster in room.monsters:
			monster.queue_free()
	rooms.clear()
	
# ready function - here level inits
func _ready():
	#if level_num == 3:
		#$AndreiKulek/Camera2D.enabled = true
		#$AlexandrUtkin/Camera2D.enabled = false
	# CLEAR EVERYTHING FROM PREVIOUS LEVELS
	clear_all()
	
	# CHOSING LEVEL INIT
	if level_num <= 2:
		metro_ready()
	elif level_num <= 4:
		forest_ready()
	else:
		nsu_ready()

func metro_ready():
	create_level_metro()
	metro = true

func _on_dialogic_signal(str):
	if str == "Start music":
		inputable = true
		GUI_Canvas.visible = true
		player.changing = false
		$MainMusic.play()
		$GUI_Canvas/Timer.start(2400)
		create_marshr()
	if str == "Tegovirish":
		inputable = true
		GUI_Canvas.visible = true
		player.changing = false
	if str == "Camera_Move":
		var i = 0
		if player == $AndreiKulek:
			while i < 30:
				await get_tree().create_timer(0.05).timeout
				$AndreiKulek/Camera2D.position += (boss.position - player.position) / 30
				$CanvasModulate/PointLight2D.position += (boss.position - player.position) / 30
				i += 1
		else:
			while i < 30:
				await get_tree().create_timer(0.05).timeout
				$AlexandrUtkin/Camera2D.position += (boss.position - player.position) / 30
				$CanvasModulate/PointLight2D.position += (boss.position - player.position) / 30
				i += 1
	if str == "End_Move":
		var i = 0
		if player == $AndreiKulek:
			while i < 30:
				await get_tree().create_timer(0.05).timeout
				$AndreiKulek/Camera2D.position -= (boss.position - player.position) / 30
				$CanvasModulate/PointLight2D.position -= (boss.position - player.position) / 30
				i += 1
			$AndreiKulek/Camera2D.position = Vector2(0, 0)
		else:
			while i < 30:
				await get_tree().create_timer(0.05).timeout
				$AlexandrUtkin/Camera2D.position -= (boss.position - player.position) / 30
				$CanvasModulate/PointLight2D.position -= (boss.position - player.position) / 30
				i += 1
			$AlexandrUtkin/Camera2D.position = Vector2(0, 0)
	if str == "Boss_Start":
		inputable = true
		var i = 0
		if player == $AndreiKulek:
			while i < 6:
				await get_tree().create_timer(0.1).timeout
				$AndreiKulek/Camera2D.zoom -= Vector2(0.1, 0.1)
				$AlexandrUtkin/Camera2D.zoom -= Vector2(0.1, 0.1)
				$CanvasModulate/PointLight2D.scale *= 1.1
				i += 1
		else:
			while i < 6:
				await get_tree().create_timer(0.1).timeout
				$AlexandrUtkin/Camera2D.zoom -= Vector2(0.1, 0.1)
				$AndreiKulek/Camera2D.zoom -= Vector2(0.1, 0.1)
				$CanvasModulate/PointLight2D.scale *= 1.1
				i += 1
		await get_tree().create_timer(1).timeout	
		notboss = false
		boss_init = false
		GUI_Canvas.visible = true
		player.changing = false
		$GUI_Canvas/Timer.start(300)
		boss.active = true
		$GUI_Canvas/GUI/BOSS.visible = true
		$GUI_Canvas/GUI/BOSS2.visible = true
		$GUI_Canvas/GUI/BOSS_HP.visible = true
		$Bossfight.play()
	if str == "THEEND":
		inputable = true
		for i in range(8):
			await get_tree().create_timer(0.1).timeout
			$CanvasModulate/PointLight2D.scale *= 0.7
		get_tree().change_scene_to_file("res://Forest/win.tscn")



func block_room(room):
	for i in room.corridors:
		match i:
			0:
				set_tile(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2-1, BLOCK_WALL)
				set_tile(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2, BLOCK_WALL)
				if forest:
					set_tile(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2+1, BLOCK_WALL)
			1:
				set_tile(room.positions.position.x, room.positions.position.y + room.positions.size.y/2-1, BLOCK_WALL)
				set_tile(room.positions.position.x, room.positions.position.y + room.positions.size.y/2, BLOCK_WALL)
				if forest:
					set_tile(room.positions.position.x, room.positions.position.y + room.positions.size.y/2+1, BLOCK_WALL)
			2:
				set_tile(room.positions.position.x + room.positions.size.x/2 + 1, room.positions.position.y + room.positions.size.y, BLOCK_WALL)
				set_tile(room.positions.position.x + room.positions.size.x/2, room.positions.position.y + room.positions.size.y, BLOCK_WALL)
				set_tile(room.positions.position.x + room.positions.size.x/2 - 1, room.positions.position.y + room.positions.size.y, BLOCK_WALL)
			3:
				if forest:
					set_tile(room.positions.position.x + room.positions.size.x/2 + 1, room.positions.position.y, BLOCK_WALL)
				set_tile(room.positions.position.x + room.positions.size.x/2, room.positions.position.y, BLOCK_WALL)
				set_tile(room.positions.position.x + room.positions.size.x/2 - 1, room.positions.position.y, BLOCK_WALL)
			_:
				pass




func unlock_room(room):
	if forest:
		for d in curr_doors:
			d.end()
	else:
		for i in room.corridors:
			match i:
				0:
					set_tile(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2-1, FLOOR)
					set_tile(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2, FLOOR)
					if forest:
						set_tile(room.positions.position.x + room.positions.size.x, room.positions.position.y + room.positions.size.y/2+1, FLOOR)
				1:
					set_tile(room.positions.position.x, room.positions.position.y + room.positions.size.y/2-1, FLOOR)
					set_tile(room.positions.position.x, room.positions.position.y + room.positions.size.y/2, FLOOR)
					if forest:
						set_tile(room.positions.position.x, room.positions.position.y + room.positions.size.y/2+1, FLOOR)
				2:
					set_tile(room.positions.position.x + room.positions.size.x/2 + 1, room.positions.position.y + room.positions.size.y, FLOOR)
					set_tile(room.positions.position.x + room.positions.size.x/2, room.positions.position.y + room.positions.size.y, FLOOR)
					set_tile(room.positions.position.x + room.positions.size.x/2 - 1, room.positions.position.y + room.positions.size.y, FLOOR)
				3:
					if forest:
						set_tile(room.positions.position.x + room.positions.size.x/2 + 1, room.positions.position.y, FLOOR)
					set_tile(room.positions.position.x + room.positions.size.x/2, room.positions.position.y, FLOOR)
					set_tile(room.positions.position.x + room.positions.size.x/2 - 1, room.positions.position.y, FLOOR)
				_:
					pass
	curr_doors.clear()


# process player function
func process_player():
	if !boss_init:
		$CanvasModulate/PointLight2D.position = player.position
	if !notboss:
		if boss.HP < 0:
			player.changing = true
			GUI_Canvas.visible = false
			$Bossfight.stop()
			await get_tree().create_timer(0.5).timeout
			inputable = false
			Dialogic.start("Victory")
			get_viewport().set_input_as_handled()
			Dialogic.signal_event.connect(_on_dialogic_signal)
	if player.dead:
		#if level_num == 3:
			#curr_marshr.exati = false
		player.changing = false
		GUI_Canvas.visible = false
		$Bossfight.stop()
		$MainMusic.stop()
		await get_tree().create_timer(0.5).timeout
		while $CanvasModulate/PointLight2D.energy > 0:
			$CanvasModulate/PointLight2D.energy -= 0.05
			await get_tree().create_timer(0.075).timeout
		get_tree().change_scene_to_file("res://Forest/dead.tscn")

	# take damage
	if player.damage_in_seconds > 0:
		var cl = clock.instantiate()
		cl.time = player.damage_in_seconds
		cl.position = player.position
		cl.position.y -= 25
		add_child(cl)
		$GUI_Canvas/Timer.start($GUI_Canvas/Timer.time_left - player.damage_in_seconds)
		player.damage_in_seconds = 0

# process monsters in rooms
func ai_rooms():
	for room in rooms:
		var pop_inds = []
		if room == current_room and room.blocked:
			for i in range(room.monsters.size()):
				if is_instance_valid(room.monsters[i]):
					room.monsters[i].ai(player)
				else:
					pop_inds.append(i)
			for i in pop_inds:
				room.monsters.pop_at(i)

func change_level_forest():
		level_num += 1
		_ready()

var current_room
####
# MAIN PROCESSING CYCLES
####

func process_rooms_forest():
	var yt = (tileMap.local_to_map(player.position)).y/2 - (tileMap.local_to_map(player.position)).x
	var xt = (tileMap.local_to_map(player.position)).y - yt
	var pos = Vector2(xt, yt)
	if current_room == rooms[rooms.size()-1]:
		if pos.y < current_room.positions.position.y+4 and level_num == 3:
			change_level_forest()
		if is_instance_valid(gnu_enter) and gnu_enter.enter:
			gnu_enter.queue_free()
			change_level_forest()
	for room in rooms:
		if room.is_in_room(pos):
				current_room = room
				if room.blocked_room() and !room.blocked:
					for x in range(room.positions.position.x, room.positions.position.x + room.positions.size.x + 1):
						for y in range(room.positions.position.y, room.positions.position.y + room.positions.size.y+1):
							tileMap.set_cell(3, iso_tile(x, y), -1)
						await get_tree().create_timer(0.015).timeout
					room.blocked = true
					block_room_forest(room)
				elif !room.blocked_room() and room.blocked:
					room.blocked = false
					room_blocking_started = false
					unlock_room(room)


var openned_tegovir = true
var boss 

func process_rooms_gnu():
	# tegovir room process
	var yt = (tileMap.local_to_map(player.position)).y/2 - (tileMap.local_to_map(player.position)).x
	var xt = (tileMap.local_to_map(player.position)).y - yt
		
	# warn for banner of opening the door
	warn = false
	for room in rooms:
		var openable = false
		
		# position of player
		var pos = Vector2(xt, yt)
		
		if room.corridors[0] == 0:
			var x = room.positions.position.x + room.positions.size.x
			var y = room.positions.position.y + room.positions.size.y/2
			if pos == Vector2(x+1, y) or pos == Vector2(x+1, y-1):
				openable = true
		elif room.corridors[0] == 1:
			var x = room.positions.position.x
			var y = room.positions.position.y + room.positions.size.y/2
			if pos == Vector2(x-2, y-2) or pos == Vector2(x-2, y-1):
				openable = true
		elif room.corridors[0] == 2:
			var x = room.positions.position.x + room.positions.size.x/2
			var y = room.positions.position.y + room.positions.size.y
			if pos == Vector2(x, y+1) or pos == Vector2(x-1, y+1):
				openable = true
		elif room.corridors[0] == 3:
			var x = room.positions.position.x + room.positions.size.x/2
			var y = room.positions.position.y
			if pos == Vector2(x, y-1) or pos == Vector2(x-1, y-1):
				openable = true
		
		if openable and room.closed:
			if room.ind in keys:
				warner.text = "НАЖМИТЕ F, ЧТОБЫ ОТКРЫТЬ ДВЕРЬ"
				if Input.is_action_just_pressed("Act"):
					doors_gnu(1, room)
			else:
				warner.text = "У ВАС НЕТ КЛЮЧА ОТ АУДИТОРИИ " + str(room.ind)
			warn = true
			
		if room.is_in_room(pos):
			current_room = room
			if room.blocked_room() and !room.blocked:
				for x in range(room.positions.position.x, room.positions.position.x + room.positions.size.x + 1):
					for y in range(room.positions.position.y, room.positions.position.y + room.positions.size.y+1):
						tileMap.set_cell(3, iso_tile(x, y), -1)
					await get_tree().create_timer(0.015).timeout
				doors_gnu(0, room)
				room.blocked = true
			elif !room.blocked_room() and room.blocked:
				room.blocked = false
				doors_gnu(1, room)
				room.table.main.play("default")
			if !room.blocked:
				if room.table.enter and room.table.contains_item:
					warner.text = "НАЖМИТЕ F, ЧТОБЫ ПОДОБРАТЬ "
					if room.key_tego:
						warner.text += "КЛЮЧ ОТ АУДИТОРИИ ТЕГОВИРА"
					elif room.work:
						warner.text += "СВОЮ РАБОТУ"
					else:
						warner.text += "КЛЮЧ ОТ КАБИНЕТА " + str(room.key)
					if Input.is_action_just_pressed("Act"):
						if room.work:
							my_work = true
							print_warn("ВЫ НАШЛИ СВОЮ РАБОТУ И КЛЮЧ ОТ АУДИТОРИИ " + str(room.key))
							keys.append(room.key)
						elif room.key_tego:
							my_key = true
							print_warn("ВЫ ПОЛУЧИЛИ КЛЮЧ ОТ АУДИТОРИИ ТЕГОВИРА")
						else:
							print_warn("ВЫ ПОЛУЧИЛИ КЛЮЧ ОТ АУДИТОРИИ " + str(room.key))
							keys.append(room.key)
							
						room.table.main.play("stand")
						room.table.bonus.play("nothing")
						room.table.contains_item = false
						
						if my_work and my_key:
							await get_tree().create_timer(2).timeout
							GUI_Canvas.visible = false
							player.changing = true
							tileMap.set_cell(2, iso_tile(120, 416), 70, Vector2(1, 0))
							inputable = false
							Dialogic.start("TegovirOpen")
							get_viewport().set_input_as_handled()
							Dialogic.signal_event.connect(_on_dialogic_signal)
					warn = true
	var poses = Vector2(xt, yt)
	if poses.x > 117 and poses.y < 418 and poses.y > 412 and level_num == 5:
		if openned_tegovir:
			if poses.x > 121 and notboss and !boss_init:
				start_bossfight(poses)
		else:
			warner.text = "ВЫ ЕЩЁ НЕ НАШЛИ СВОЙ ПРОЕКТ И КЛЮЧ"
			warn = true

var notboss = true

func start_bossfight(poses):
	boss_init = true
	$MainMusic.stop()
	tileMap.set_cell(2, iso_tile(120, 416), 70, Vector2(0, 0))
	GUI_Canvas.visible = false
	
	boss = tegovir.instantiate()
	add_child(boss)
	boss.position = isom(poses.x+10, poses.y)
	await get_tree().create_timer(1).timeout
	player.changing = true
	inputable = false
	Dialogic.start("Bossfight")
	get_viewport().set_input_as_handled()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	


func print_warn(text):
	warner.text = text
	dial = true
	await get_tree().create_timer(3).timeout
	dial = false

	

#####
# MAIN FUNCTION
#####

func _process(delta):
	if warn or dial:
		warner.visible = true
	else:
		warner.visible = false
	input_process()
	GUI_Canvas.gui_draw(player, $AndreiKulek)
	$GUI_Canvas/GUI/STAMINKA3/PLAYER.text = $MainMusic.now_playing()
	process_player()
	ai_rooms()
	if !notboss and !boss_init:
		boss.plr = player
		$GUI_Canvas/GUI/BOSS_HP.set_size(Vector2((int(boss.HP*700/boss.MAX_HP)), 35))
	if forest:
		process_rooms_forest()
	else:
		process_rooms_gnu()
	#print(player.position)




# function of disappear-appear character
func dis_appear(flag):
	if !flag:
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 0.75)
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 0.5)
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 0.25)
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 0)
	else:
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 0.25)
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 0.5)
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 0.75)
		await get_tree().create_timer(0.05).timeout
		player.modulate = Color(1, 1, 1, 1)

####
# INPUT FUNCTIONS AND ETC
####

var inputable = true

func input_process():
	if inputable:
		if Input.is_action_just_pressed("next_song"):
			$MainMusic.forward()
		if Input.is_action_just_pressed("prev_song"):
			$MainMusic.backward()
		if Input.is_action_just_pressed("stopplay"):
			$MainMusic.play_stop()
		if Input.is_action_just_pressed("Alex"):
			
			if player == $AndreiKulek:
				$GUI_Canvas/Active.position.y += 32*4
				$AlexandrUtkin.modulate = Color(1, 1, 1, 0)
				dis_appear(0)
				$AlexandrUtkin.show()
				$AlexandrUtkin.changing = false
				
				player.hide()
				player.box.disabled = true
				player.changing = true
				
				$AlexandrUtkin.position = player.position
				
				player = $AlexandrUtkin
				$AlexandrUtkin.box.disabled = false
				$AndreiKulek.position = Vector2(-1000, -1000)
				$AndreiKulek/Camera2D.enabled = false
				$AlexandrUtkin/Camera2D.enabled = true
				dis_appear(1)
				
				
		if Input.is_action_just_pressed("Andrew"):
			if player == $AlexandrUtkin:
				$GUI_Canvas/Active.position.y -= 32*4
				$AndreiKulek.modulate = Color(1, 1, 1, 0)
				dis_appear(0)
				$AndreiKulek.show()
				$AndreiKulek.changing = false
				
				player.hide()
				player.box.disabled = true
				player.changing = true
				
				$AndreiKulek.position = player.position
				
				player = $AndreiKulek
				$AndreiKulek.box.disabled = false
				$AlexandrUtkin.position = Vector2(-1000, -1000)
				$AlexandrUtkin/Camera2D.enabled = false
				$AndreiKulek/Camera2D.enabled = true
				dis_appear(1)


#########
# SIGNAL FUNCTIONS
####

func _on_next_door_pressed():
	level_num += 1
	_ready()
	
#func _on_andre_button_pressed():
	#var prev_x = player.position.x
	#var prev_y = player.position.y
	#if player == $AlexandrUtkin:
		#$AndreiKulek.show()
		#player.hide()
		#player.changing = true
		#$AndreiKulek.position = player.position
		#player = $AndreiKulek
		#$AndreiKulek/Camera2D.enabled = true
		#$AlexandrUtkin/Camera2D.enabled = false
		#$AlexandrUtkin.position = Vector2(-1000, -1000)
#
#func _on_alex_button_pressed():
	#var prev_x = player.position.x
	#var prev_y = player.position.y
	#if player == $AndreiKulek:
		#$AlexandrUtkin.show()
		#player.hide()
		#player.changing = true
		#$AlexandrUtkin.position = player.position
		#player = $AlexandrUtkin
		#$AndreiKulek/Camera2D.enabled = false
		#$AlexandrUtkin/Camera2D.enabled = true
		#$AndreiKulek.position = Vector2(-1000, -1000)

func _on_alex_button_mouse_entered():
	player.changing = true

func _on_alex_button_mouse_exited():
	player.changing = false

func _on_andre_button_mouse_entered():
	player.changing = true

func _on_andre_button_mouse_exited():
	player.changing = false



####
# END OF SIGNAL FUNCTIONS
#########


func _on_timer_timeout():
	player.dead = true
