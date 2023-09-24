extends CanvasLayer
var colors_option = ["ff1414","3a97b4","3ea249","df4fd7","957918"]

@onready var colorbox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
signal close_panel
signal set_mach_color(color)


func _ready():
	set_mach_color.emit(colors_option[0])
	for coloropt in colorbox.get_children():
		var idx = coloropt.get_index() 
		if idx ==0: 
			coloropt.picked=true
		coloropt.color = Color(colors_option[idx])
		coloropt.touched.connect(Callable(self,"on_touched"))
	
func on_touched(colbox): 
	# picked this one 
	colbox.picked = true
	# unpick all the other
	for coloropt in colorbox.get_children(): 
		if coloropt != colbox: 
			coloropt.picked=false
	# set color machine
	set_mach_color.emit(colbox.color)





func _on_ok_pressed():
	self.visible=false
	close_panel.emit()
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
