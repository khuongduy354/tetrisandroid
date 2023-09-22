extends Node2D
class_name Block

var still =false 
var board:Board = null

func _initialize(b:Board):
	board = b 

func _ready(): 
	pass
func drop_tile(baseline): 
	for tile in $BlockTiles.get_children(): 
		var pos = board.map_to_board(tile.global_position)
		if pos.y < baseline: 
			pos.y += 1
			tile.global_position = board.map_to_world(pos)
func clear_tile(pos): 
	for tile in $BlockTiles.get_children(): 
		var tile_pos =  board.map_to_board(tile.global_position)
		if tile_pos == pos: 
			$BlockTiles.remove_child(tile)
			tile.queue_free()
			if $BlockTiles.get_child_count() ==0: 
				queue_free()
			return tile
#func get_tile_from_pos(coor): 
#	for tile in $BlockTiles.get_children(): 
#		if Global.map_to_board(tile.global_position) == coor:
#			return tile
#	return null
#func clear_tile(coor): 
#	var tile = get_tile_from_pos(coor)
#	if tile:
#		$BlockTiles.remove_child(tile)
#		tile.queue_free()
#		if $BlockTiles.get_child_count() == 0: 
#			self.queue_free()
func set_still(): 
	still = true
	Events.to_still.emit($BlockTiles)
	$down_timer.stop()
	
var rotating = false 
func instant_down(): 
	if rotating:
		return 
	


	# collisions 
	while true:
		for tile in $BlockTiles.get_children(): 
			var additional_pos = Vector2(0,1)
			if board.check_colliding(tile,additional_pos): 
				set_still()
				SfxManager.play(SfxManager.DROP)
				return

		var next_pos =Vector2($BlockTiles.global_position.x,$BlockTiles.global_position.y + Global.CELL_SIZE)
		$BlockTiles.global_position = next_pos

func down(): 
	if rotating:
		return 

	var next_pos =Vector2($BlockTiles.global_position.x,$BlockTiles.global_position.y + Global.CELL_SIZE)

	# collisions 
	for tile in $BlockTiles.get_children(): 
		var additional_pos = Vector2(0,1)
		if board.check_colliding(tile,additional_pos): 
			set_still()
			return 
	SfxManager.play(SfxManager.MOVEMENT)
	$BlockTiles.global_position = next_pos
func left():
	var next_pos = Vector2($BlockTiles.global_position.x-Global.CELL_SIZE, $BlockTiles.global_position.y)
	
	# collision 
	for tile in $BlockTiles.get_children(): 
		var addition_pos = Vector2(-1,0)
		if board.check_colliding(tile,addition_pos): 
			return 
	SfxManager.play(SfxManager.MOVEMENT)
	$BlockTiles.global_position = next_pos
func right(): 
	var next_pos = Vector2($BlockTiles.global_position.x+Global.CELL_SIZE,$BlockTiles.global_position.y)
	
	# collision 
	for tile in $BlockTiles.get_children(): 
		var addition_pos = Vector2(1,0)
		if board.check_colliding(tile,addition_pos): 
			return 
	SfxManager.play(SfxManager.MOVEMENT)
	$BlockTiles.global_position = next_pos

func rotate_block(): 
	rotating = true 
	
	board.check_tile_colliding_rotation($BlockTiles,90)

	rotating = false
	
func print_tiles(): 
	for tile in $BlockTiles.get_children(): 
		print(board.map_to_board(tile.global_position))
func _physics_process(delta):
	if still or rotating: 
		return
	if Input.is_action_just_pressed("instant_down"):
		instant_down()
	if Input.is_action_pressed("ui_down"): 
		if $down_cooldown.is_stopped():
			down()
			$down_timer.stop()
			$down_timer.start()
			$down_cooldown.start()
	if Input.is_action_just_pressed("ui_up"): 
		if !rotating: 
			rotate_block()
	if Input.is_action_pressed("ui_left"): 
		if $down_cooldown.is_stopped() :
			left()
			$down_cooldown.start()
	if Input.is_action_pressed("ui_right"): 
		if $down_cooldown.is_stopped():
			right()
			$down_cooldown.start()
			

func _on_down_timer_timeout():
	if still or rotating: 
		return
	down()
