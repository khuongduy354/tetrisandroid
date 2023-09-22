extends Sprite2D

func _ready():
	Events.next.connect(Callable(self,"_on_next"))
func clear_current_block(): 
	for child in get_children(): 
		if child is Block: 
			child.queue_free()
func _on_next(block): 
	if !block: 
		return
	clear_current_block()
	var _block = block.duplicate()
	_block.get_node("down_timer").stop()
	add_child(_block)
	_block.set_physics_process(false)
	_block.global_position = $Marker2D.global_position
