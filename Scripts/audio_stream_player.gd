extends AudioStreamPlayer

func _ready():
	connect("finished", Callable(self, "_on_track_finished"))
	SettingsData._load_data()
	print(SettingsData.soundBool)
	if SettingsData.soundBool:
		play_track()

#var tracks = {
	#"a_rise": preload("res://MUSIC/Rise.wav"),
	#"b_dino": preload("res://MUSIC/kim_lightyear_-_dino_instrumental.wav"),
	#"c_neon": preload("res://MUSIC/neocrey - NEON.mp3"),
	#"d_disco": preload("res://MUSIC/Disco Century.wav")
#}

var tracks_array=[
	preload("res://MUSIC/Rise.wav"),
	preload("res://MUSIC/kim_lightyear_-_dino_instrumental.wav"),
	preload("res://MUSIC/neocrey - NEON.mp3"),
	preload("res://MUSIC/Disco Century.wav")]

var current_index = 0

func play_track():
	if SettingsData.soundBool:
		stream = tracks_array[current_index]
		volume_db = -20 
		play()


func _on_finished() -> void:
	current_index = (current_index + 1) % tracks_array.size()
	play_track()
	
func fade_to_track(next_stream: AudioStream, duration: float = 4.0):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -40, duration / 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): _set_stream(next_stream))
	tween.tween_property(self, "volume_db", -20, duration / 2).set_trans(Tween.TRANS_SINE)
	
func _set_stream(next_stream: AudioStream):
	stream = next_stream
	if SettingsData.soundBool:
		play()
