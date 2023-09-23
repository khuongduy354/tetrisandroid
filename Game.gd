extends Node2D

@onready var board = $MainScreen/TetrisBoard

func _ready():
	board.start_game()
func cs():
	SfxManager.play(SfxManager.CLICK)
	
	

func _on_pause_pressed():
	cs()
	if board.game_paused:
		board.resume_game()
	else: 
		board.pause_game()


func _on_sound_pressed():
	cs()
	var muted = AudioServer.is_bus_mute(0)
	AudioServer.set_bus_mute(0,!muted)


func _on_reset_pressed():
	board.reset_game()
	cs()
	pass # Replace with function body.


func _on_rotate_pressed():
	Input.action_press("ui_up")
	cs()
	pass # Replace with function body.

func shakey(): 
	$Camera2D.offset.y=-10
#	await get_tree().create_timer(0.1).timeout
#	$Camera2D.offset.y=0
	
func _on_down_pressed():
	Input.action_press("instant_down")
	shakey()
	pass # Replace with function body.


func _on_slow_down_pressed():
	Input.action_press("ui_down")
	
	pass # Replace with function body.


func _on_right_pressed():
	Input.action_press("ui_right")
	
	pass # Replace with function body.


func _on_left_pressed():
	Input.action_press("ui_left")
	pass # Replace with function body.
