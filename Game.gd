extends Node2D

@onready var board = $MainScreen/TetrisBoard
var muted = AudioServer.is_bus_mute(0): set = set_mute 
@onready var mach =$BigMachine

func set_mute(val): 
	muted = val 
	if muted: 
		$Soundicon.self_modulate =Color(1,1,1,1)
	else: 
		$Soundicon.self_modulate =Color(1,1,1,0.1)
		
		
func _ready():
	board.start_game()
	board.is_paused.connect(Callable(self,"_on_pause"))
	$OptionPanel.close_panel.connect(Callable(self,"_on_close_panel"))
	$OptionPanel.set_mach_color.connect(Callable(self,"_on_set_mach_color"))
func _on_set_mach_color(color): 
	mach.self_modulate=color
func _on_pause(is_pause): 
	if !is_pause: 
		$Pauseicon.self_modulate = Color(1,1,1,0.1)
	else: 
		$Pauseicon.self_modulate = Color(1,1,1,1)
func cs():
	SfxManager.play(SfxManager.CLICK)
	
	
# fullscreen 
# level label 
# exit buttons, option buttons
# change color skin 
# admob 



func _on_pause_pressed():
	cs()
	if board.game_paused:
		board.resume_game()
	else: 
		board.pause_game()


func _on_sound_pressed():
	cs()
	muted = AudioServer.is_bus_mute(0)
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

func _on_close_panel(): 
	board.resume_game()

func _on_small_button_4_pressed():
	# OPTION button 
	board.pause_game()
	$OptionPanel.visible = true
	pass 
