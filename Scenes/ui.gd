extends CanvasLayer

@onready var score_label = $Score
@onready var dot_manager = $"../DotManager" # Dot manager name is awful. 

func _ready():
	dot_manager.connect("score_increased", Callable(self,"_update_score_label"))
	
func _update_score_label(amt : int):
	#print("SIGNAL REIECVED")
	score_label.text = "Score: " + str(amt)
