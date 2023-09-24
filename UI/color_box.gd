extends ColorRect
signal touched
@export var picked = false: set = set_pick 
func set_pick(val): 
	picked = val 
	if picked: 
		$ColorRect.visible=true
	else: 
		$ColorRect.visible=false
func _ready():
	picked = picked
	
func _gui_input(event):
	if event is InputEventScreenTouch: 
		if event.is_pressed(): 
			touched.emit(self)
