extends CanvasLayer


@onready var hp = $GUI/HP
#@onready var hp_bar = $GUI/HP_BAR
@onready var stamina_bar = $GUI/STAMINA_BAR
@onready var mini_character = $Control/SubViewportContainer/SubViewport/Mini/MiniChar
@onready var mp_bar = $GUI/MP_BAR
@onready var timer_t = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func gui_draw(player):
	var minutes = int(timer_t.get_time_left()) / 60
	var seconds = int(timer_t.get_time_left()) % 60
	
	var m0 = ''
	var s0 = ''
	
	if minutes < 10:
		m0 = '0'
	if seconds < 10:
		s0 = '0'
	hp.text = "Time:   " + m0 + str(minutes) + ":" + s0 + str(seconds)
	#hp_bar.set_size(Vector2((int(player.HP*200/player.MAX_HP)), 35))
	mp_bar.set_size(Vector2((int(player.MP*100/player.MAX_MP)), 35))
	stamina_bar.set_size(Vector2(int((player.STAMINA*120)/player.MAX_STAMINA), 35))
	mini_character.position = player.position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
