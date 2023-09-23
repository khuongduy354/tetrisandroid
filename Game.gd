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
	Events.game_over.emit()
	cs()
	pass # Replace with function body.


func _on_rotate_pressed():
	if board.current_block: 
		board.current_block.rotate_block()
	cs()
	pass # Replace with function body.

	
func _on_down_pressed():
	if board.current_block: 
		board.current_block.instant_down()
	pass # Rt55eplace with function body.


func _on_slow_down_pressed():
	if board.current_block: 
		board.current_block.down()
	pass # Replace with function body.


func _on_right_pressed():
	if board.current_block: 
		board.current_block.right()
	pass # Replace with function body.


func _on_left_pressed():
	if board.current_block: 
		board.current_block.left()
	pass # Replace with function body.
