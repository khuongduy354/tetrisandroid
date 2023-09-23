extends Control
var score = 0:set=set_score
func _ready():
	Events.scored.connect(Callable(self,"_on_scored"))
	Events.game_over.connect(func():score=0)
func set_score(s:int): 
	score = s
	load_score(score)
func _on_scored(_score): 
	score+=_score
func clear_score_UI(): 
	for child in $realscores.get_children():
		child.queue_free()
func load_score(number): 
	clear_score_UI()
	if number == 0: 
		return
	var string_score = str(number)
	var len = string_score.length()
	for i in range(len):
		var pos_idx = 6-1-i
		var str_idx = len-1-i
		var char = string_score[str_idx]
		var path = "res://assets/fullasset/" + char +".png"
		var node = Sprite2D.new()
		node.texture = load(path)
		$realscores.add_child(node)

		node.global_position = $placeholders.get_child(pos_idx).global_position
		
