extends CanvasLayer

@onready var score_label = $Score
@onready var dot_manager = $"../DotManager" # Dot manager name is awful. 
@onready var level_label = $Level
@onready var timer_label = $Timer
@onready var background = $"../Background/BackTexture"
@onready var streak_label = $Streak

func _ready():
	dot_manager.connect("score_increased", Callable(self,"_update_score_label"))
	dot_manager.connect("level_increased", Callable(self,"_update_level_label"))
	dot_manager.connect("level_increased", Callable(self,"_update_background_color"))
	dot_manager.connect("timer_update", Callable(self,"_update_timer_label"))
	#background.modulate = Color.from_hsv(160.0/360.0,70/100.0,40/100.0,1)
	
	dot_manager.connect("streak_change", Callable(self,"_update_streak_label"))
func _update_score_label(amt : int):
	#print("SIGNAL REIECVED")
	score_label.text = "Score: " + str(amt)
	
func _update_level_label(amt : int):
	#print("SIGNAL REIECVED")
	level_label.text = "Level: " + str(amt)

func _update_timer_label(amt :int):
	timer_label.text = "Time: " + str(amt)

func _update_streak_label(amt :int):
	streak_label.text = "Streak: " + str(amt)
	

func _update_background_color(amt : int):
	print("CALLED UPDATE BACKGROUND COLOR: " + str(amt))
	match amt:
		2:
			background.modulate = Color.from_hsv(160.0/360.0,70/100.0,40/100.0,1)
			#background.modulate = Color.from_hsv(200.0/360.0,70/100.0,40/100.0,1)
		3:
			background.modulate = Color.from_hsv(200/360.0,70/100.0,40/100.0,1)
		4:
			background.modulate = Color.from_hsv(220/360.0,70/100.0,40/100.0,1)
		5:
			background.modulate = Color.from_hsv(280/360.0,70/100.0,40/100.0,1)
		6:
			background.modulate = Color.from_hsv(320.0/360.0,70/100.0,40/100.0,1)
		7:
			background.modulate = Color.from_hsv(360.0/360.0,70/100.0,40/100.0,1)
		8:
			background.modulate = Color.from_hsv(240.0/360.0,0/100.0,20/100.0,1)
			
			
			



func _on_quit_pressed() -> void:
	##TODO - This really SHould be pause, and then provide settings
	## quit retry etc.
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
