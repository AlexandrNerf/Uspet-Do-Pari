extends AudioStreamPlayer

var compositions_name = ["Cherez \nLes", "Blizzard", "FOCUS", "Uspet \nDo Pari"]
var streams = ["res://Music/Cherez Les.mp3", "res://Music/BLIZZARD.mp3", "res://Music/FOCUS.mp3", "res://Music/UspetDoPari.mp3"]

var now_music = 0

func now_playing():
	return compositions_name[now_music]

func _ready():
	pass

func play_stop():
	if playing:
		self.stop()
	else:
		self.play()
	
func forward():
	now_music = (now_music + 1) % streams.size()
	stream = load(streams[now_music])
	self.play()
	
func backward():
	now_music = (now_music - 1) % streams.size()
	stream = load(streams[now_music])
	self.play()
	
func _process(delta):
	pass

func _on_finished():
	now_music = (now_music + 1) % streams.size()
	stream = load(streams[now_music])
	self.play()
