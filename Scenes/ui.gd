extends CanvasLayer

@onready var score_label = $Score
@onready var dot_manager = $"../DotManager" # Dot manager name is awful. 
@onready var level_label = $Level
@onready var timer_label = $Timer

func _ready():
	dot_manager.connect("score_increased", Callable(self,"_update_score_label"))
	dot_manager.connect("level_increased", Callable(self,"_update_level_label"))
	dot_manager.connect("timer_update", Callable(self,"_update_timer_label"))
func _update_score_label(amt : int):
	#print("SIGNAL REIECVED")
	score_label.text = "Score: " + str(amt)
	
func _update_level_label(amt : int):
	#print("SIGNAL REIECVED")
	level_label.text = "Level: " + str(amt)

func _update_timer_label(amt :int):
	timer_label.text = "Time: " + str(amt)
